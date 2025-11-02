const { google } = require("googleapis")

class GoogleCalendarService {
  constructor() {
    this.oauth2Client = new google.auth.OAuth2(
      process.env.GOOGLE_CLIENT_ID,
      process.env.GOOGLE_CLIENT_SECRET,
      process.env.GOOGLE_REDIRECT_URI,
    )
  }

  setCredentials(tokens) {
    this.oauth2Client.setCredentials(tokens)
  }

  async createCalendarEvent(eventDetails) {
    const calendar = google.calendar({ version: "v3", auth: this.oauth2Client })

    const event = {
      summary: `Tutoring Session: ${eventDetails.subject}`,
      description: `Tutoring session between ${eventDetails.studentName} and ${eventDetails.teacherName}`,
      start: {
        dateTime: eventDetails.startTime,
        timeZone: eventDetails.timeZone || "UTC",
      },
      end: {
        dateTime: eventDetails.endTime,
        timeZone: eventDetails.timeZone || "UTC",
      },
      attendees: [{ email: eventDetails.studentEmail }, { email: eventDetails.teacherEmail }],
      conferenceData: {
        createRequest: {
          requestId: `meet-${Date.now()}`,
          conferenceSolutionKey: { type: "hangoutsMeet" },
        },
      },
      reminders: {
        useDefault: false,
        overrides: [
          { method: "email", minutes: 24 * 60 }, // 1 day before
          { method: "popup", minutes: 30 }, // 30 minutes before
        ],
      },
    }

    try {
      const response = await calendar.events.insert({
        calendarId: "primary",
        resource: event,
        conferenceDataVersion: 1,
      })

      return {
        eventId: response.data.id,
        meetLink: response.data.conferenceData?.entryPoints?.[0]?.uri || null,
        htmlLink: response.data.htmlLink,
      }
    } catch (error) {
      console.error("Error creating calendar event:", error)
      throw new Error("Failed to create calendar event")
    }
  }

  async updateCalendarEvent(eventId, updates) {
    const calendar = google.calendar({ version: "v3", auth: this.oauth2Client })

    try {
      const response = await calendar.events.patch({
        calendarId: "primary",
        eventId: eventId,
        resource: updates,
      })

      return response.data
    } catch (error) {
      console.error("Error updating calendar event:", error)
      throw new Error("Failed to update calendar event")
    }
  }

  async deleteCalendarEvent(eventId) {
    const calendar = google.calendar({ version: "v3", auth: this.oauth2Client })

    try {
      await calendar.events.delete({
        calendarId: "primary",
        eventId: eventId,
      })

      return true
    } catch (error) {
      console.error("Error deleting calendar event:", error)
      throw new Error("Failed to delete calendar event")
    }
  }
}

module.exports = GoogleCalendarService
