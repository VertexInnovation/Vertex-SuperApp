const express = require("express")
const { verifyToken, requireRole } = require("../middleware/auth")
const CalendlyService = require("../services/CalendlyService")
const UserService = require("../services/UserService")
const { ErrorTracker } = require("../middleware/monitoring")
const router = express.Router()

// Get Calendly OAuth URL (teachers only)
router.get("/connect", verifyToken, requireRole(["teacher"]), async (req, res) => {
  try {
    const calendlyService = new CalendlyService()
    const authUrl = calendlyService.generateAuthUrl(req.user.uid)

    res.json({
      authUrl,
      message: "Visit this URL to connect your Calendly account",
    })
  } catch (error) {
    await ErrorTracker.logError(error, req, { action: "calendly_connect" })
    res.status(500).json({ error: "Failed to generate Calendly authorization URL" })
  }
})

// Handle Calendly OAuth callback
router.post("/callback", async (req, res) => {
  try {
    const { code, state } = req.body

    if (!code || !state) {
      return res.status(400).json({ error: "Authorization code and state are required" })
    }

    const teacherId = state
    const calendlyService = new CalendlyService()

    await calendlyService.handleOAuthCallback(code, teacherId)

    res.json({
      message: "Calendly connected successfully",
      teacherId,
    })
  } catch (error) {
    await ErrorTracker.logError(error, req, { action: "calendly_callback" })
    res.status(500).json({ error: "Failed to connect Calendly" })
  }
})

// Disconnect Calendly (teachers only)
router.delete("/disconnect", verifyToken, requireRole(["teacher"]), async (req, res) => {
  try {
    const calendlyService = new CalendlyService()
    await calendlyService.disconnectCalendly(req.user.uid)

    res.json({ message: "Calendly disconnected successfully" })
  } catch (error) {
    await ErrorTracker.logError(error, req, { action: "calendly_disconnect" })
    res.status(500).json({ error: "Failed to disconnect Calendly" })
  }
})

// Get teacher's Calendly event types
router.get("/event-types", verifyToken, requireRole(["teacher"]), async (req, res) => {
  try {
    const calendlyService = new CalendlyService()
    const eventTypes = await calendlyService.getEventTypes(req.user.uid)

    res.json({ eventTypes })
  } catch (error) {
    await ErrorTracker.logError(error, req, { action: "calendly_event_types" })
    res.status(500).json({ error: "Failed to fetch Calendly event types" })
  }
})

// Get available times for a specific event type
router.get("/available-times", verifyToken, requireRole(["teacher"]), async (req, res) => {
  try {
    const { eventTypeUri, startDate, endDate } = req.query

    if (!eventTypeUri || !startDate || !endDate) {
      return res.status(400).json({
        error: "Event type URI, start date, and end date are required",
      })
    }

    const calendlyService = new CalendlyService()
    const availableTimes = await calendlyService.getAvailableTimes(
      req.user.uid,
      eventTypeUri,
      new Date(startDate),
      new Date(endDate),
    )

    res.json({ availableTimes })
  } catch (error) {
    await ErrorTracker.logError(error, req, { action: "calendly_available_times" })
    res.status(500).json({ error: "Failed to fetch available times" })
  }
})

// Get Calendly connection status
router.get("/status", verifyToken, requireRole(["teacher"]), async (req, res) => {
  try {
    const teacher = await UserService.getUserById(req.user.uid)

    res.json({
      connected: teacher.calendlyConnected || false,
      hasTokens: !!teacher.calendlyTokens?.access_token,
    })
  } catch (error) {
    await ErrorTracker.logError(error, req, { action: "calendly_status" })
    res.status(500).json({ error: "Failed to check Calendly status" })
  }
})

// Get teacher's Calendly user information
router.get("/user", verifyToken, requireRole(["teacher"]), async (req, res) => {
  try {
    const calendlyService = new CalendlyService()
    const user = await calendlyService.getCalendlyUser(req.user.uid)

    res.json({ user })
  } catch (error) {
    await ErrorTracker.logError(error, req, { action: "calendly_user" })
    res.status(500).json({ error: "Failed to fetch Calendly user information" })
  }
})

// Webhook endpoint for Calendly events
router.post("/webhook", async (req, res) => {
  try {
    const signature = req.headers["calendly-webhook-signature"]
    const payload = req.body

    const calendlyService = new CalendlyService()
    await calendlyService.handleWebhook(payload, signature)

    res.status(200).json({ message: "Webhook processed successfully" })
  } catch (error) {
    await ErrorTracker.logError(error, req, { action: "calendly_webhook" })
    res.status(500).json({ error: "Failed to process webhook" })
  }
})

module.exports = router
