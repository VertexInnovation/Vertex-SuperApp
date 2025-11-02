const express = require("express")
const cors = require("cors")
const helmet = require("helmet")
require("dotenv").config()

const authRoutes = require("./routes/auth")
const teacherRoutes = require("./routes/teachers")
const studentRoutes = require("./routes/students")
const sessionRoutes = require("./routes/sessions")
const calendarRoutes = require("./routes/calendar")
const calendlyRoutes = require("./routes/calendly")

const { apiRateLimit, securityHeaders, sanitizeInput, requestLogger, sessionTimeout } = require("./middleware/security")
const { ErrorTracker, performanceMonitor, apiUsageTracker, healthCheck } = require("./middleware/monitoring")

const app = express()
const PORT = process.env.PORT || 3000

app.use(
  helmet({
    contentSecurityPolicy: false, // We set our own CSP
    crossOriginEmbedderPolicy: false,
  }),
)
app.use(securityHeaders)
app.use(performanceMonitor)
app.use(requestLogger)

app.use(
  cors({
    origin: process.env.FRONTEND_URL || "http://localhost:3000",
    credentials: true,
    methods: ["GET", "POST", "PUT", "PATCH", "DELETE"],
    allowedHeaders: ["Content-Type", "Authorization"],
  }),
)

app.use(express.json({ limit: "10mb" }))
app.use(express.urlencoded({ extended: true, limit: "10mb" }))
app.use(sanitizeInput)
app.use(apiRateLimit)
app.use(apiUsageTracker)
app.use(sessionTimeout(120)) // 2 hour session timeout

// Routes
app.use("/api/auth", authRoutes)
app.use("/api/teachers", teacherRoutes)
app.use("/api/students", studentRoutes)
app.use("/api/sessions", sessionRoutes)
app.use("/api/calendar", calendarRoutes)
app.use("/api/calendly", calendlyRoutes)

app.get("/health", healthCheck)

app.use(async (err, req, res, next) => {
  // Log the error
  await ErrorTracker.logError(err, req, {
    body: req.body,
    query: req.query,
    params: req.params,
  })

  // Security event logging for certain errors
  if (err.status === 401 || err.status === 403) {
    await ErrorTracker.logSecurityEvent("UNAUTHORIZED_ACCESS", req, {
      error: err.message,
    })
  }

  console.error(err.stack)

  // Don't leak error details in production
  const isDevelopment = process.env.NODE_ENV === "development"

  res.status(err.status || 500).json({
    error: isDevelopment ? err.message : "Internal server error",
    ...(isDevelopment && { stack: err.stack }),
    timestamp: new Date().toISOString(),
  })
})

// 404 handler
app.use("*", async (req, res) => {
  await ErrorTracker.logSecurityEvent("NOT_FOUND", req, {
    attemptedPath: req.originalUrl,
  })

  res.status(404).json({
    error: "Route not found",
    path: req.originalUrl,
    timestamp: new Date().toISOString(),
  })
})

// Graceful shutdown
process.on("SIGTERM", () => {
  console.log("SIGTERM received, shutting down gracefully")
  process.exit(0)
})

process.on("SIGINT", () => {
  console.log("SIGINT received, shutting down gracefully")
  process.exit(0)
})

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`)
  console.log(`Environment: ${process.env.NODE_ENV || "development"}`)
})

module.exports = app
