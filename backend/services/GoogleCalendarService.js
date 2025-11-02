const { google } = require("googleapis")
const { db } = require("../config/firebase")

class GoogleCalendarService {
  constructor() {
    this.oauth2Client = new google.auth.OAuth2(
      process.env.GOOGLE_CLIENT_ID,
      process.env.GOOGLE_CLIENT_SECRET,
      process.env.GOOGLE_REDIRECT_URI,
    )
  }

  // Generate OAuth URL for teacher to connect their Google Calendar
  generateAuthUrl(teacherId) {
    const scopes = ["https://www.googleapis.com/auth/calendar", "https://www.googleapis.com/auth/calendar.events"]

    return this.oauth2Client.generateAuthUrl({
      access_type: "offline",
      scope: scopes,
      state: teacherId, // Pass teacher ID to identify user after OAuth
      prompt: "consent", // Force consent screen to get refresh token
    })
  }

  // Handle OAuth callback and store tokens
  async handleOAuthCallback(code, teacherId) {
    try {
      const { tokens } = await this.oauth2Client.getAccessToken(code)

      // Store tokens in Firestore for the teacher
      await db
        .collection("users")
        .doc(teacherId)
        .update({
          googleCalendarTokens: {
            access_token: tokens.access_token,
            refresh_token: tokens.refresh_token,
            expiry_date: tokens.expiry_date,
          },
          googleCalendarConnected: true,
          updatedAt: new Date().toISOString(),
        })

      return tokens
    } catch (error) {
      console.error("OAuth callback error:", error)
      throw new Error("Failed to handle OAuth callback")
    }
  }

  // Set credentials from stored tokens
  async setCredentialsForTeacher(teacherId) {
    try {
      const teacherDoc = await db.collection("users").doc(teacherId).get()
      const teacherData = teacherDoc.data()

      if (!teacherData.googleCalendarTokens) {
        throw new Error("Teacher has not connected Google Calendar")
      }

      this.oauth2Client.setCredentials(teacherData.googleCalendarTokens)

      // Check if token needs refresh
      if (teacherData.googleCalendarTokens.expiry_date < Date.now()) {
        await this.refreshTokens(teacherId)
      }
    } catch (error) {
      console.error("Error setting credentials:", error)
      throw new Error("Failed to set Google Calendar credentials")
    }
  }

  // Refresh expired tokens
  async refreshTokens(teacherId) {
    try {
      const { credentials } = await this.oauth2Client.refreshAccessToken()

      await db.collection("users").doc(teacherId).update({
        googleCalendarTokens: credentials,
        updatedAt: new Date().toISOString(),
      })

      this.oauth2Client.setCredentials(credentials)
    } catch (error) {
      console.error("Token refresh error:", error)
      throw new Error("Failed to refresh tokens")
    }
  }

  // Create a calendar event for a tutoring session
  async createTutoringEvent(sessionData) {
    try {
      await this.setCredentialsForTeacher(sessionData.teacherId)

      const calendar = google.calendar({ version: "v3", auth: this.oauth2Client })

      const event = {
        summary: `Tutoring Session: ${sessionData.subject}`,
        description: `Tutoring session between ${sessionData.studentName} and ${sessionData.teacherName}\n\nSubject: ${sessionData.subject}\n\nNotes: ${sessionData.notes || "No additional notes"}`,
        start: {
          dateTime: sessionData.startTime,
          timeZone: sessionData.timeZone || "UTC",
        },
        end: {
          dateTime: sessionData.endTime,
          timeZone: sessionData.timeZone || "UTC",
        },
        attendees: [
          { email: sessionData.studentEmail, responseStatus: "accepted" },
          { email: sessionData.teacherEmail, responseStatus: "accepted" },
        ],
        conferenceData: {
          createRequest: {
            requestId: `meet-${sessionData.sessionId}-${Date.now()}`,
            conferenceSolutionKey: { type: "hangoutsMeet" },
          },
        },
        reminders: {
          useDefault: false,
          overrides: [
            { method: "email", minutes: 24 * 60 }, // 1 day before
            { method: "email", minutes: 60 }, // 1 hour before
            { method: "popup", minutes: 15 }, // 15 minutes before
          ],
        },
        guestsCanModify: false,
        guestsCanInviteOthers: false,
        guestsCanSeeOtherGuests: true,
      }

      const response = await calendar.events.insert({
        calendarId: "primary",
        resource: event,
        conferenceDataVersion: 1,
        sendUpdates: "all", // Send email invitations
      })

      return {
        eventId: response.data.id,
        meetLink: response.data.conferenceData?.entryPoints?.[0]?.uri || null,
        htmlLink: response.data.htmlLink,
        status: response.data.status,
      }
    } catch (error) {
      console.error("Error creating calendar event:", error)
      throw new Error("Failed to create calendar event")
    }
  }

  // Update an existing calendar event
  async updateTutoringEvent(teacherId, eventId, updates) {
    try {
      await this.setCredentialsForTeacher(teacherId)

      const calendar = google.calendar({ version: "v3", auth: this.oauth2Client })

      const updateData = {}

      if (updates.startTime && updates.endTime) {
        updateData.start = {
          dateTime: updates.startTime,
          timeZone: updates.timeZone || "UTC",
        }
        updateData.end = {
          dateTime: updates.endTime,
          timeZone: updates.timeZone || "UTC",
        }
      }

      if (updates.notes) {
        // Get current event to preserve other description content
        const currentEvent = await calendar.events.get({
          calendarId: "primary",
          eventId: eventId,
        })

        const currentDescription = currentEvent.data.description || ""
        const notesSection = `\n\nNotes: ${updates.notes}`

        // Replace or add notes section
        if (currentDescription.includes("\n\nNotes:")) {
          updateData.description = currentDescription.replace(/\n\nNotes:.*$/, notesSection)
        } else {
          updateData.description = currentDescription + notesSection
        }
      }

      if (updates.status === "cancelled") {
        updateData.status = "cancelled"
      }

      const response = await calendar.events.patch({
        calendarId: "primary",
        eventId: eventId,
        resource: updateData,
        sendUpdates: "all",
      })

      return {
        eventId: response.data.id,
        status: response.data.status,
        htmlLink: response.data.htmlLink,
      }
    } catch (error) {
      console.error("Error updating calendar event:", error)
      throw new Error("Failed to update calendar event")
    }
  }

  // Cancel a calendar event
  async cancelTutoringEvent(teacherId, eventId) {
    try {
      await this.setCredentialsForTeacher(teacherId)

      const calendar = google.calendar({ version: "v3", auth: this.oauth2Client })

      await calendar.events.patch({
        calendarId: "primary",
        eventId: eventId,
        resource: { status: "cancelled" },
        sendUpdates: "all",
      })

      return true
    } catch (error) {
      console.error("Error cancelling calendar event:", error)
      throw new Error("Failed to cancel calendar event")
    }
  }

  // Get teacher's calendar events for availability checking
  async getTeacherEvents(teacherId, startDate, endDate) {
    try {
      await this.setCredentialsForTeacher(teacherId)

      const calendar = google.calendar({ version: "v3", auth: this.oauth2Client })

      const response = await calendar.events.list({
        calendarId: "primary",
        timeMin: startDate.toISOString(),
        timeMax: endDate.toISOString(),
        singleEvents: true,
        orderBy: "startTime",
      })

      return response.data.items.map((event) => ({
        id: event.id,
        summary: event.summary,
        start: event.start.dateTime || event.start.date,
        end: event.end.dateTime || event.end.date,
        status: event.status,
      }))
    } catch (error) {
      console.error("Error fetching calendar events:", error)
      throw new Error("Failed to fetch calendar events")
    }
  }

  // Check if teacher is available based on their Google Calendar
  async checkTeacherAvailability(teacherId, startTime, endTime) {
    try {
      const start = new Date(startTime)
      const end = new Date(endTime)

      // Get events for the day
      const dayStart = new Date(start)
      dayStart.setHours(0, 0, 0, 0)
      const dayEnd = new Date(start)
      dayEnd.setHours(23, 59, 59, 999)

      const events = await this.getTeacherEvents(teacherId, dayStart, dayEnd)

      // Check for conflicts
      const hasConflict = events.some((event) => {
        if (event.status === "cancelled") return false

        const eventStart = new Date(event.start)
        const eventEnd = new Date(event.end)

        // Check for time overlap
        return start < eventEnd && end > eventStart
      })

      return !hasConflict
    } catch (error) {
      console.error("Error checking calendar availability:", error)
      // If we can't check calendar, assume unavailable for safety
      return false
    }
  }

  // Disconnect Google Calendar for a teacher
  async disconnectCalendar(teacherId) {
    try {
      await db.collection("users").doc(teacherId).update({
        googleCalendarTokens: null,
        googleCalendarConnected: false,
        updatedAt: new Date().toISOString(),
      })

      return true
    } catch (error) {
      console.error("Error disconnecting calendar:", error)
      throw new Error("Failed to disconnect calendar")
    }
  }
}

module.exports = GoogleCalendarService
