const { auth } = require("../config/firebase")

// Middleware to verify Firebase JWT tokens
const verifyToken = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({ error: "No token provided" })
    }

    const token = authHeader.split(" ")[1]
    const decodedToken = await auth.verifyIdToken(token)

    req.user = decodedToken
    next()
  } catch (error) {
    console.error("Token verification error:", error)
    return res.status(401).json({ error: "Invalid token" })
  }
}

// Middleware to check user role
const requireRole = (roles) => {
  return async (req, res, next) => {
    try {
      if (!req.user) {
        return res.status(401).json({ error: "Authentication required" })
      }

      // Get user role from Firestore
      const { db } = require("../config/firebase")
      const userDoc = await db.collection("users").doc(req.user.uid).get()

      if (!userDoc.exists) {
        return res.status(404).json({ error: "User not found" })
      }

      const userData = userDoc.data()
      const userRole = userData.role

      if (!roles.includes(userRole)) {
        return res.status(403).json({ error: "Insufficient permissions" })
      }

      req.userRole = userRole
      req.userData = userData
      next()
    } catch (error) {
      console.error("Role verification error:", error)
      return res.status(500).json({ error: "Role verification failed" })
    }
  }
}

module.exports = { verifyToken, requireRole }
