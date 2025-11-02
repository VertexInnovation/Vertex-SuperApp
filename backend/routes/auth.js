const express = require("express")
const { auth, db } = require("../config/firebase")
const { validateEmail } = require("../utils/validation")
const { authRateLimit, validateRegistration, validateLogin, enhancedVerifyToken } = require("../middleware/security")
const { ErrorTracker } = require("../middleware/monitoring")
const router = express.Router()

router.use(authRateLimit)

// Register a new user (students can use email/password, teachers must use Google)
router.post("/register", validateRegistration, async (req, res) => {
  try {
    const { email, password, name, role, subjects } = req.body

    // Teachers must use Google login only
    if (role === "teacher" && password) {
      await ErrorTracker.logSecurityEvent("INVALID_TEACHER_REGISTRATION", req, {
        email,
        role,
      })

      return res.status(400).json({
        error: "Teachers must register using Google login only",
        redirectTo: "/auth/google",
      })
    }

    // Students can use email/password
    if (role === "student" && !password) {
      return res.status(400).json({ error: "Password is required for student registration" })
    }

    let userRecord
    if (role === "student") {
      // Create user with email/password
      userRecord = await auth.createUser({
        email,
        password,
        displayName: name,
      })
    } else {
      return res.status(400).json({
        error: "Teachers must register through Google OAuth",
        redirectTo: "/auth/google",
      })
    }

    // Create user document in Firestore
    const userData = {
      id: userRecord.uid,
      name,
      email,
      role,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    }

    if (role === "teacher") {
      userData.subjects = subjects || []
      userData.availability = []
      userData.googleCalendarConnected = false
      userData.calendlyConnected = false
    }

    await db.collection("users").doc(userRecord.uid).set(userData)

    res.status(201).json({
      message: "User registered successfully",
      user: {
        uid: userRecord.uid,
        email: userRecord.email,
        name,
        role,
      },
    })
  } catch (error) {
    await ErrorTracker.logError(error, req, { action: "registration" })

    if (error.code === "auth/email-already-exists") {
      return res.status(400).json({ error: "Email already exists" })
    }

    if (error.code === "auth/weak-password") {
      return res.status(400).json({ error: "Password is too weak" })
    }

    res.status(500).json({ error: "Registration failed" })
  }
})

// Login with email/password (students only)
router.post("/login", validateLogin, async (req, res) => {
  try {
    const { email, password } = req.body

    // Note: In a real app, you would handle login on the client side with Firebase Auth
    // This endpoint is mainly for validation and user data retrieval
    const userRecord = await auth.getUserByEmail(email)
    const userDoc = await db.collection("users").doc(userRecord.uid).get()

    if (!userDoc.exists) {
      return res.status(404).json({ error: "User profile not found" })
    }

    const userData = userDoc.data()

    // Teachers should not use email/password login
    if (userData.role === "teacher") {
      await ErrorTracker.logSecurityEvent("INVALID_TEACHER_LOGIN", req, {
        email,
        role: userData.role,
      })

      return res.status(400).json({
        error: "Teachers must login using Google",
        redirectTo: "/auth/google",
      })
    }

    res.json({
      message: "Login successful",
      user: {
        uid: userRecord.uid,
        email: userRecord.email,
        name: userData.name,
        role: userData.role,
      },
    })
  } catch (error) {
    await ErrorTracker.logError(error, req, { action: "login" })

    if (error.code === "auth/user-not-found") {
      return res.status(404).json({ error: "User not found" })
    }

    res.status(500).json({ error: "Login failed" })
  }
})

// Google OAuth callback handler
router.post("/google/callback", async (req, res) => {
  try {
    const { idToken, role } = req.body

    if (!idToken) {
      return res.status(400).json({ error: "ID token is required" })
    }

    // Verify the Google ID token
    const decodedToken = await auth.verifyIdToken(idToken)
    const { uid, email, name, picture } = decodedToken

    // Check if user already exists
    let userDoc = await db.collection("users").doc(uid).get()

    if (!userDoc.exists) {
      // Create new user
      if (!role || !["student", "teacher"].includes(role)) {
        return res.status(400).json({ error: "Valid role is required for new users" })
      }

      const userData = {
        id: uid,
        name: name || decodedToken.name,
        email,
        role,
        picture: picture || null,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
        googleConnected: true,
      }

      if (role === "teacher") {
        userData.subjects = []
        userData.availability = []
        userData.googleCalendarConnected = false
        userData.calendlyConnected = false
      }

      await db.collection("users").doc(uid).set(userData)
      userDoc = await db.collection("users").doc(uid).get()
    }

    const userData = userDoc.data()

    res.json({
      message: "Google authentication successful",
      user: {
        uid,
        email,
        name: userData.name,
        role: userData.role,
        picture: userData.picture,
      },
    })
  } catch (error) {
    console.error("Google auth error:", error)
    res.status(500).json({ error: "Google authentication failed" })
  }
})

// Get current user profile
router.get("/profile", enhancedVerifyToken, async (req, res) => {
  try {
    const userDoc = await db.collection("users").doc(req.user.uid).get()

    if (!userDoc.exists) {
      return res.status(404).json({ error: "User profile not found" })
    }

    const userData = userDoc.data()

    res.json({
      user: {
        uid: req.user.uid,
        email: userData.email,
        name: userData.name,
        role: userData.role,
        picture: userData.picture,
        subjects: userData.subjects,
        availability: userData.availability,
        googleCalendarConnected: userData.googleCalendarConnected,
        calendlyConnected: userData.calendlyConnected,
      },
    })
  } catch (error) {
    await ErrorTracker.logError(error, req, { action: "profile_fetch" })
    res.status(500).json({ error: "Failed to fetch profile" })
  }
})

// Logout (mainly for cleanup)
router.post("/logout", async (req, res) => {
  try {
    // In Firebase, logout is typically handled on the client side
    // This endpoint can be used for any server-side cleanup
    res.json({ message: "Logout successful" })
  } catch (error) {
    console.error("Logout error:", error)
    res.status(500).json({ error: "Logout failed" })
  }
})

// Connect Google Calendar (for teachers)
router.post("/connect-google-calendar", async (req, res) => {
  try {
    const authHeader = req.headers.authorization

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({ error: "No token provided" })
    }

    const token = authHeader.split(" ")[1]
    const decodedToken = await auth.verifyIdToken(token)

    const userDoc = await db.collection("users").doc(decodedToken.uid).get()

    if (!userDoc.exists) {
      return res.status(404).json({ error: "User not found" })
    }

    const userData = userDoc.data()

    if (userData.role !== "teacher") {
      return res.status(403).json({ error: "Only teachers can connect Google Calendar" })
    }

    // Update user's Google Calendar connection status
    await db.collection("users").doc(decodedToken.uid).update({
      googleCalendarConnected: true,
      updatedAt: new Date().toISOString(),
    })

    res.json({ message: "Google Calendar connected successfully" })
  } catch (error) {
    console.error("Google Calendar connection error:", error)
    res.status(500).json({ error: "Failed to connect Google Calendar" })
  }
})

module.exports = router
