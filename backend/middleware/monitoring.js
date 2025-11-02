const { db } = require("../config/firebase")

// Error tracking and monitoring
class ErrorTracker {
  static async logError(error, req, additionalInfo = {}) {
    try {
      const errorLog = {
        message: error.message,
        stack: error.stack,
        timestamp: new Date().toISOString(),
        method: req.method,
        path: req.path,
        userId: req.user?.uid || "anonymous",
        ip: req.ip,
        userAgent: req.get("User-Agent"),
        ...additionalInfo,
      }

      // Log to Firestore for persistence
      await db.collection("error_logs").add(errorLog)

      // Log to console for development
      console.error("Error logged:", errorLog)
    } catch (loggingError) {
      console.error("Failed to log error:", loggingError)
    }
  }

  static async logSecurityEvent(eventType, req, details = {}) {
    try {
      const securityLog = {
        eventType,
        timestamp: new Date().toISOString(),
        method: req.method,
        path: req.path,
        userId: req.user?.uid || "anonymous",
        ip: req.ip,
        userAgent: req.get("User-Agent"),
        details,
      }

      await db.collection("security_logs").add(securityLog)
      console.warn("Security event logged:", securityLog)
    } catch (loggingError) {
      console.error("Failed to log security event:", loggingError)
    }
  }
}

// Performance monitoring middleware
const performanceMonitor = (req, res, next) => {
  const start = process.hrtime.bigint()

  res.on("finish", async () => {
    const end = process.hrtime.bigint()
    const duration = Number(end - start) / 1000000 // Convert to milliseconds

    // Log slow requests (> 1 second)
    if (duration > 1000) {
      try {
        await db.collection("performance_logs").add({
          method: req.method,
          path: req.path,
          duration,
          statusCode: res.statusCode,
          userId: req.user?.uid || "anonymous",
          timestamp: new Date().toISOString(),
        })

        console.warn(`Slow request detected: ${req.method} ${req.path} - ${duration}ms`)
      } catch (error) {
        console.error("Failed to log performance data:", error)
      }
    }
  })

  next()
}

// API usage tracking
const apiUsageTracker = async (req, res, next) => {
  try {
    const usage = {
      endpoint: `${req.method} ${req.path}`,
      userId: req.user?.uid || "anonymous",
      timestamp: new Date().toISOString(),
      ip: req.ip,
    }

    // Track usage asynchronously to not block the request
    setImmediate(async () => {
      try {
        await db.collection("api_usage").add(usage)
      } catch (error) {
        console.error("Failed to track API usage:", error)
      }
    })
  } catch (error) {
    console.error("API usage tracking error:", error)
  }

  next()
}

// Health check endpoint data
const healthCheck = async (req, res) => {
  try {
    const health = {
      status: "healthy",
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      memory: process.memoryUsage(),
      version: process.env.npm_package_version || "unknown",
    }

    // Check Firebase connection
    try {
      await db.collection("health_check").limit(1).get()
      health.database = "connected"
    } catch (dbError) {
      health.database = "disconnected"
      health.status = "degraded"
    }

    res.json(health)
  } catch (error) {
    res.status(500).json({
      status: "unhealthy",
      error: error.message,
      timestamp: new Date().toISOString(),
    })
  }
}

module.exports = {
  ErrorTracker,
  performanceMonitor,
  apiUsageTracker,
  healthCheck,
}
