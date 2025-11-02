const rateLimit = require("express-rate-limit")
const { body, validationResult } = require("express-validator")
const { auth } = require("../config/firebase")

// Rate limiting configurations
const createRateLimiter = (windowMs, max, message) => {
  return rateLimit({
    windowMs,
    max,
    message: { error: message },
    standardHeaders: true,
    legacyHeaders: false,
    handler: (req, res) => {
      res.status(429).json({
        error: message,
        retryAfter: Math.ceil(windowMs / 1000),
      })
    },
  })
}

// Different rate limits for different endpoints
const authRateLimit = createRateLimiter(
  15 * 60 * 1000, // 15 minutes
  5, // 5 attempts
  "Too many authentication attempts, please try again later",
)

const apiRateLimit = createRateLimiter(
  15 * 60 * 1000, // 15 minutes
  100, // 100 requests
  "Too many API requests, please try again later",
)

const bookingRateLimit = createRateLimiter(
  60 * 60 * 1000, // 1 hour
  10, // 10 bookings
  "Too many booking attempts, please try again later",
)

// Input validation middleware
const handleValidationErrors = (req, res, next) => {
  const errors = validationResult(req)
  if (!errors.isEmpty()) {
    return res.status(400).json({
      error: "Validation failed",
      details: errors.array(),
    })
  }
  next()
}

// Validation rules
const validateRegistration = [
  body("email").isEmail().normalizeEmail().withMessage("Valid email is required"),
  body("name").trim().isLength({ min: 2, max: 50 }).withMessage("Name must be 2-50 characters"),
  body("role").isIn(["student", "teacher"]).withMessage("Role must be student or teacher"),
  body("password")
    .optional()
    .isLength({ min: 6 })
    .withMessage("Password must be at least 6 characters")
    .matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
    .withMessage("Password must contain at least one lowercase, uppercase, and number"),
  body("subjects").optional().isArray().withMessage("Subjects must be an array"),
  handleValidationErrors,
]

const validateLogin = [
  body("email").isEmail().normalizeEmail().withMessage("Valid email is required"),
  body("password").notEmpty().withMessage("Password is required"),
  handleValidationErrors,
]

const validateSessionBooking = [
  body("teacherId").notEmpty().withMessage("Teacher ID is required"),
  body("subject").trim().isLength({ min: 1, max: 50 }).withMessage("Subject is required"),
  body("startTime").isISO8601().withMessage("Valid start time is required"),
  body("endTime").isISO8601().withMessage("Valid end time is required"),
  body("platform").optional().isIn(["google", "calendly"]).withMessage("Platform must be google or calendly"),
  body("notes").optional().trim().isLength({ max: 500 }).withMessage("Notes must be less than 500 characters"),
  handleValidationErrors,
]

const validateAvailability = [
  body("startTime").isISO8601().withMessage("Valid start time is required"),
  body("endTime").isISO8601().withMessage("Valid end time is required"),
  body("recurring").optional().isBoolean().withMessage("Recurring must be boolean"),
  body("dayOfWeek").optional().isInt({ min: 0, max: 6 }).withMessage("Day of week must be 0-6 (Sunday-Saturday)"),
  handleValidationErrors,
]

// Enhanced authentication middleware with additional security checks
const enhancedVerifyToken = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({ error: "No token provided" })
    }

    const token = authHeader.split(" ")[1]

    // Verify token length (basic sanity check)
    if (token.length < 100) {
      return res.status(401).json({ error: "Invalid token format" })
    }

    const decodedToken = await auth.verifyIdToken(token)

    // Check if token is not expired (additional check)
    const now = Math.floor(Date.now() / 1000)
    if (decodedToken.exp < now) {
      return res.status(401).json({ error: "Token expired" })
    }

    // Check if token was issued recently (prevent very old tokens)
    const tokenAge = now - decodedToken.iat
    const maxAge = 24 * 60 * 60 // 24 hours
    if (tokenAge > maxAge) {
      return res.status(401).json({ error: "Token too old, please re-authenticate" })
    }

    req.user = decodedToken
    next()
  } catch (error) {
    console.error("Token verification error:", error)

    if (error.code === "auth/id-token-expired") {
      return res.status(401).json({ error: "Token expired" })
    }

    if (error.code === "auth/id-token-revoked") {
      return res.status(401).json({ error: "Token revoked" })
    }

    return res.status(401).json({ error: "Invalid token" })
  }
}

// Resource ownership verification
const verifyResourceOwnership = (resourceType) => {
  return async (req, res, next) => {
    try {
      const { db } = require("../config/firebase")
      const resourceId = req.params.sessionId || req.params.teacherId || req.params.studentId

      if (!resourceId) {
        return res.status(400).json({ error: "Resource ID is required" })
      }

      let hasAccess = false

      switch (resourceType) {
        case "session":
          const sessionDoc = await db.collection("sessions").doc(resourceId).get()
          if (sessionDoc.exists) {
            const sessionData = sessionDoc.data()
            hasAccess = sessionData.studentId === req.user.uid || sessionData.teacherId === req.user.uid
          }
          break

        case "teacher":
          hasAccess = resourceId === req.user.uid
          break

        case "student":
          hasAccess = resourceId === req.user.uid
          break

        default:
          return res.status(400).json({ error: "Invalid resource type" })
      }

      if (!hasAccess) {
        return res.status(403).json({ error: "Access denied to this resource" })
      }

      next()
    } catch (error) {
      console.error("Resource ownership verification error:", error)
      res.status(500).json({ error: "Failed to verify resource ownership" })
    }
  }
}

// Request logging middleware
const requestLogger = (req, res, next) => {
  const start = Date.now()

  // Log request
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.path}`, {
    ip: req.ip,
    userAgent: req.get("User-Agent"),
    userId: req.user?.uid || "anonymous",
  })

  // Log response
  res.on("finish", () => {
    const duration = Date.now() - start
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.path} - ${res.statusCode} (${duration}ms)`)
  })

  next()
}

// Security headers middleware
const securityHeaders = (req, res, next) => {
  // Remove server information
  res.removeHeader("X-Powered-By")

  // Add security headers
  res.setHeader("X-Content-Type-Options", "nosniff")
  res.setHeader("X-Frame-Options", "DENY")
  res.setHeader("X-XSS-Protection", "1; mode=block")
  res.setHeader("Referrer-Policy", "strict-origin-when-cross-origin")
  res.setHeader("Permissions-Policy", "geolocation=(), microphone=(), camera=()")

  // Content Security Policy
  res.setHeader(
    "Content-Security-Policy",
    "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; connect-src 'self' https://api.firebase.com https://googleapis.com",
  )

  next()
}

// Input sanitization middleware
const sanitizeInput = (req, res, next) => {
  const sanitize = (obj) => {
    if (typeof obj === "string") {
      // Remove potential XSS patterns
      return obj
        .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, "")
        .replace(/javascript:/gi, "")
        .replace(/on\w+\s*=/gi, "")
        .trim()
    }

    if (typeof obj === "object" && obj !== null) {
      const sanitized = {}
      for (const [key, value] of Object.entries(obj)) {
        sanitized[key] = sanitize(value)
      }
      return sanitized
    }

    return obj
  }

  if (req.body) {
    req.body = sanitize(req.body)
  }

  if (req.query) {
    req.query = sanitize(req.query)
  }

  next()
}

// Session timeout middleware
const sessionTimeout = (timeoutMinutes = 60) => {
  return (req, res, next) => {
    if (req.user) {
      const now = Math.floor(Date.now() / 1000)
      const sessionAge = now - req.user.iat
      const maxAge = timeoutMinutes * 60

      if (sessionAge > maxAge) {
        return res.status(401).json({
          error: "Session expired due to inactivity",
          code: "SESSION_TIMEOUT",
        })
      }
    }

    next()
  }
}

// IP whitelist middleware (for admin endpoints)
const ipWhitelist = (allowedIPs = []) => {
  return (req, res, next) => {
    const clientIP = req.ip || req.connection.remoteAddress

    if (allowedIPs.length > 0 && !allowedIPs.includes(clientIP)) {
      return res.status(403).json({
        error: "Access denied from this IP address",
      })
    }

    next()
  }
}

module.exports = {
  // Rate limiting
  authRateLimit,
  apiRateLimit,
  bookingRateLimit,

  // Validation
  validateRegistration,
  validateLogin,
  validateSessionBooking,
  validateAvailability,
  handleValidationErrors,

  // Authentication
  enhancedVerifyToken,
  verifyResourceOwnership,

  // Security
  securityHeaders,
  sanitizeInput,
  requestLogger,
  sessionTimeout,
  ipWhitelist,
}
