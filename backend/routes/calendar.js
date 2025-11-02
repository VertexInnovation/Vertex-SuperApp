const express = require("express")
const { verifyToken, requireRole } = require("../middleware/auth")
const GoogleCalendarService = require("../services/GoogleCalendarService")
const UserService = require("../services/UserService")
const router = express.Router()

// Get Google Calendar OAuth URL (teachers only)
router.get("/connect", verifyToken, requireRole(["teacher"]), async (req, res) => {
  try {
    const calendarService = new GoogleCalendarService()
    const authUrl = calendarService.generateAuthUrl(req.user.uid)

    res.json({
      authUrl,
      message: "Visit this URL to connect your Google Calendar",
    })
  } catch (error) {
    console.error("Error generating auth URL:", error)
    res.status(500).json({ error: "Failed to generate authorization URL" })
  }
})

// Handle Google Calendar OAuth callback
router.post("/callback", async (req, res) => {
  try {
    const { code, state } = req.body

    if (!code || !state) {
      return res.status(400).json({ error: "Authorization code and state are required" })
    }

    const teacherId = state
    const calendarService = new GoogleCalendarService()

    await calendarService.handleOAuthCallback(code, teacherId)

    res.json({
      message: "Google Calendar connected successfully",
      teacherId,
    })
  } catch (error) {
    console.error("OAuth callback error:", error)
    res.status(500).json({ error: "Failed to connect Google Calendar" })
  }
})

// Disconnect Google Calendar (teachers only)
router.delete("/disconnect", verifyToken, requireRole(["teacher"]), async (req, res) => {
  try {
    const calendarService = new GoogleCalendarService()
    await calendarService.disconnectCalendar(req.user.uid)

    res.json({ message: "Google Calendar disconnected successfully" })
  } catch (error) {
    console.error("Error disconnecting calendar:", error)
    res.status(500).json({ error: "Failed to disconnect Google Calendar" })
  }
})

// Get teacher's calendar events (for availability checking)
router.get("/events", verifyToken, requireRole(["teacher"]), async (req, res) => {
  try {
    const { startDate, endDate } = req.query

    if (!startDate || !endDate) {
      return res.status(400).json({ error: "Start date and end date are required" })
    }

    const calendarService = new GoogleCalendarService()
    const events = await calendarService.getTeacherEvents(req.user.uid, new Date(startDate), new Date(endDate))

    res.json({ events })
  } catch (error) {
    console.error("Error fetching calendar events:", error)
    res.status(500).json({ error: "Failed to fetch calendar events" })
  }
})

// Check availability for a specific time slot
router.post("/check-availability", verifyToken, requireRole(["teacher"]), async (req, res) => {
  try {
    const { startTime, endTime } = req.body

    if (!startTime || !endTime) {
      return res.status(400).json({ error: "Start time and end time are required" })
    }

    const calendarService = new GoogleCalendarService()
    const isAvailable = await calendarService.checkTeacherAvailability(req.user.uid, startTime, endTime)

    res.json({
      available: isAvailable,
      startTime,
      endTime,
    })
  } catch (error) {
    console.error("Error checking availability:", error)
    res.status(500).json({ error: "Failed to check availability" })
  }
})

// Get calendar connection status
router.get("/status", verifyToken, requireRole(["teacher"]), async (req, res) => {
  try {
    const teacher = await UserService.getUserById(req.user.uid)

    res.json({
      connected: teacher.googleCalendarConnected || false,
      hasTokens: !!teacher.googleCalendarTokens?.access_token,
    })
  } catch (error) {
    console.error("Error checking calendar status:", error)
    res.status(500).json({ error: "Failed to check calendar status" })
  }
})

module.exports = router
