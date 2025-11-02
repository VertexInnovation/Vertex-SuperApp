const axios = require("axios")
const { db } = require("../config/firebase")

class CalendlyService {
  constructor() {
    this.baseURL = "https://api.calendly.com"
    this.clientId = process.env.CALENDLY_CLIENT_ID
    this.clientSecret = process.env.CALENDLY_CLIENT_SECRET
    this.redirectUri = process.env.CALENDLY_REDIRECT_URI
  }

  // Generate OAuth URL for teacher to connect their Calendly account
  generateAuthUrl(teacherId) {
    const scopes = "default"
    const state = teacherId

    return `https://auth.calendly.com/oauth/authorize?client_id=${this.clientId}&response_type=code&redirect_uri=${encodeURIComponent(this.redirectUri)}&scope=${scopes}&state=${state}`
  }

  // Handle OAuth callback and store tokens
  async handleOAuthCallback(code, teacherId) {
    try {
      const tokenResponse = await axios.post("https://auth.calendly.com/oauth/token", {
        grant_type: "authorization_code",
        client_id: this.clientId,
        client_secret: this.clientSecret,
        redirect_uri: this.redirectUri,
        code: code,
      })

      const tokens = tokenResponse.data

      // Store tokens in Firestore for the teacher
      await db
        .collection("users")
        .doc(teacherId)
        .update({
          calendlyTokens: {
            access_token: tokens.access_token,
            refresh_token: tokens.refresh_token,
            expires_at: Date.now() + tokens.expires_in * 1000,
            token_type: tokens.token_type,
          },
          calendlyConnected: true,
          updatedAt: new Date().toISOString(),
        })

      return tokens
    } catch (error) {
      console.error("Calendly OAuth callback error:", error)
      throw new Error("Failed to handle Calendly OAuth callback")
    }
  }

  // Get access token for teacher (refresh if needed)
  async getAccessToken(teacherId) {
    try {
      const teacherDoc = await db.collection("users").doc(teacherId).get()
      const teacherData = teacherDoc.data()

      if (!teacherData.calendlyTokens) {
        throw new Error("Teacher has not connected Calendly")
      }

      const tokens = teacherData.calendlyTokens

      // Check if token needs refresh
      if (Date.now() >= tokens.expires_at) {
        const refreshResponse = await axios.post("https://auth.calendly.com/oauth/token", {
          grant_type: "refresh_token",
          client_id: this.clientId,
          client_secret: this.clientSecret,
          refresh_token: tokens.refresh_token,
        })

        const newTokens = refreshResponse.data

        // Update tokens in Firestore
        const updatedTokens = {
          access_token: newTokens.access_token,
          refresh_token: newTokens.refresh_token || tokens.refresh_token,
          expires_at: Date.now() + newTokens.expires_in * 1000,
          token_type: newTokens.token_type,
        }

        await db.collection("users").doc(teacherId).update({
          calendlyTokens: updatedTokens,
          updatedAt: new Date().toISOString(),
        })

        return updatedTokens.access_token
      }

      return tokens.access_token
    } catch (error) {
      console.error("Error getting Calendly access token:", error)
      throw new Error("Failed to get Calendly access token")
    }
  }

  // Get teacher's Calendly user information
  async getCalendlyUser(teacherId) {
    try {
      const accessToken = await this.getAccessToken(teacherId)

      const response = await axios.get(`${this.baseURL}/users/me`, {
        headers: {
          Authorization: `Bearer ${accessToken}`,
          "Content-Type": "application/json",
        },
      })

      return response.data.resource
    } catch (error) {
      console.error("Error fetching Calendly user:", error)
      throw new Error("Failed to fetch Calendly user information")
    }
  }

  // Get teacher's event types (available meeting types)
  async getEventTypes(teacherId) {
    try {
      const accessToken = await this.getAccessToken(teacherId)
      const user = await this.getCalendlyUser(teacherId)

      const response = await axios.get(`${this.baseURL}/event_types`, {
        headers: {
          Authorization: `Bearer ${accessToken}`,
          "Content-Type": "application/json",
        },
        params: {
          user: user.uri,
          active: true,
        },
      })

      return response.data.collection
    } catch (error) {
      console.error("Error fetching Calendly event types:", error)
      throw new Error("Failed to fetch Calendly event types")
    }
  }

  // Get available time slots for a specific event type
  async getAvailableTimes(teacherId, eventTypeUri, startDate, endDate) {
    try {
      const accessToken = await this.getAccessToken(teacherId)

      const response = await axios.get(`${this.baseURL}/event_type_available_times`, {
        headers: {
          Authorization: `Bearer ${accessToken}`,
          "Content-Type": "application/json",
        },
        params: {
          event_type: eventTypeUri,
          start_time: startDate.toISOString(),
          end_time: endDate.toISOString(),
        },
      })

      return response.data.collection
    } catch (error) {
      console.error("Error fetching available times:", error)
      throw new Error("Failed to fetch available times")
    }
  }

  // Create a scheduled event (booking)
  async createScheduledEvent(teacherId, eventTypeUri, startTime, inviteeInfo) {
    try {
      const accessToken = await this.getAccessToken(teacherId)

      const response = await axios.post(
        `${this.baseURL}/scheduled_events`,
        {
          event_type: eventTypeUri,
          start_time: startTime,
          invitees: [
            {
              email: inviteeInfo.email,
              name: inviteeInfo.name,
            },
          ],
        },
        {
          headers: {
            Authorization: `Bearer ${accessToken}`,
            "Content-Type": "application/json",
          },
        },
      )

      return response.data.resource
    } catch (error) {
      console.error("Error creating Calendly event:", error)
      throw new Error("Failed to create Calendly event")
    }
  }

  // Get scheduled event details
  async getScheduledEvent(teacherId, eventUri) {
    try {
      const accessToken = await this.getAccessToken(teacherId)

      const response = await axios.get(eventUri, {
        headers: {
          Authorization: `Bearer ${accessToken}`,
          "Content-Type": "application/json",
        },
      })

      return response.data.resource
    } catch (error) {
      console.error("Error fetching scheduled event:", error)
      throw new Error("Failed to fetch scheduled event")
    }
  }

  // Cancel a scheduled event
  async cancelScheduledEvent(teacherId, eventUri, reason = "Cancelled by system") {
    try {
      const accessToken = await this.getAccessToken(teacherId)

      const response = await axios.post(
        `${eventUri}/cancellation`,
        {
          reason: reason,
        },
        {
          headers: {
            Authorization: `Bearer ${accessToken}`,
            "Content-Type": "application/json",
          },
        },
      )

      return response.data.resource
    } catch (error) {
      console.error("Error cancelling Calendly event:", error)
      throw new Error("Failed to cancel Calendly event")
    }
  }

  // Get invitee information for an event
  async getEventInvitees(teacherId, eventUri) {
    try {
      const accessToken = await this.getAccessToken(teacherId)

      const response = await axios.get(`${this.baseURL}/scheduled_events/${eventUri}/invitees`, {
        headers: {
          Authorization: `Bearer ${accessToken}`,
          "Content-Type": "application/json",
        },
      })

      return response.data.collection
    } catch (error) {
      console.error("Error fetching event invitees:", error)
      throw new Error("Failed to fetch event invitees")
    }
  }

  // Disconnect Calendly for a teacher
  async disconnectCalendly(teacherId) {
    try {
      await db.collection("users").doc(teacherId).update({
        calendlyTokens: null,
        calendlyConnected: false,
        updatedAt: new Date().toISOString(),
      })

      return true
    } catch (error) {
      console.error("Error disconnecting Calendly:", error)
      throw new Error("Failed to disconnect Calendly")
    }
  }

  // Webhook handler for Calendly events
  async handleWebhook(payload, signature) {
    try {
      // Verify webhook signature (implement based on Calendly's webhook security)
      // This is a simplified version - implement proper signature verification

      const event = payload.event
      const eventType = payload.event_type

      switch (eventType) {
        case "invitee.created":
          await this.handleInviteeCreated(event)
          break
        case "invitee.canceled":
          await this.handleInviteeCanceled(event)
          break
        default:
          console.log(`Unhandled Calendly webhook event: ${eventType}`)
      }

      return true
    } catch (error) {
      console.error("Error handling Calendly webhook:", error)
      throw new Error("Failed to handle Calendly webhook")
    }
  }

  // Handle invitee created webhook
  async handleInviteeCreated(event) {
    try {
      // Find the corresponding session in our database
      const sessionsSnapshot = await db.collection("sessions").where("calendlyEventUri", "==", event.uri).limit(1).get()

      if (!sessionsSnapshot.empty) {
        const sessionDoc = sessionsSnapshot.docs[0]
        await sessionDoc.ref.update({
          status: "confirmed",
          calendlyEventId: event.uuid,
          meet_link: event.location?.join_url || null,
          updatedAt: new Date().toISOString(),
        })
      }
    } catch (error) {
      console.error("Error handling invitee created:", error)
    }
  }

  // Handle invitee canceled webhook
  async handleInviteeCanceled(event) {
    try {
      // Find the corresponding session in our database
      const sessionsSnapshot = await db.collection("sessions").where("calendlyEventUri", "==", event.uri).limit(1).get()

      if (!sessionsSnapshot.empty) {
        const sessionDoc = sessionsSnapshot.docs[0]
        await sessionDoc.ref.update({
          status: "cancelled",
          updatedAt: new Date().toISOString(),
        })
      }
    } catch (error) {
      console.error("Error handling invitee canceled:", error)
    }
  }
}

module.exports = CalendlyService
