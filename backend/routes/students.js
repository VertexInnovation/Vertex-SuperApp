const express = require("express")
const { db } = require("../config/firebase")
const { verifyToken, requireRole } = require("../middleware/auth")
const router = express.Router()

// Get student profile
router.get("/profile", verifyToken, requireRole(["student"]), async (req, res) => {
  try {
    const userDoc = await db.collection("users").doc(req.user.uid).get()

    if (!userDoc.exists) {
      return res.status(404).json({ error: "Student profile not found" })
    }

    const userData = userDoc.data()

    res.json({
      student: {
        id: userData.id,
        name: userData.name,
        email: userData.email,
        picture: userData.picture,
        createdAt: userData.createdAt,
      },
    })
  } catch (error) {
    console.error("Error fetching student profile:", error)
    res.status(500).json({ error: "Failed to fetch student profile" })
  }
})

// Update student profile
router.put("/profile", verifyToken, requireRole(["student"]), async (req, res) => {
  try {
    const { name } = req.body

    if (!name) {
      return res.status(400).json({ error: "Name is required" })
    }

    await db.collection("users").doc(req.user.uid).update({
      name,
      updatedAt: new Date().toISOString(),
    })

    res.json({ message: "Profile updated successfully" })
  } catch (error) {
    console.error("Error updating student profile:", error)
    res.status(500).json({ error: "Failed to update profile" })
  }
})

// Get student's booked sessions
router.get("/sessions", verifyToken, requireRole(["student"]), async (req, res) => {
  try {
    const sessionsSnapshot = await db
      .collection("sessions")
      .where("studentId", "==", req.user.uid)
      .orderBy("start_time", "desc")
      .get()

    const sessions = []
    for (const doc of sessionsSnapshot.docs) {
      const sessionData = doc.data()

      // Get teacher information
      const teacherDoc = await db.collection("users").doc(sessionData.teacherId).get()
      const teacherData = teacherDoc.exists ? teacherDoc.data() : null

      sessions.push({
        id: doc.id,
        ...sessionData,
        teacher: teacherData
          ? {
              name: teacherData.name,
              email: teacherData.email,
              subjects: teacherData.subjects,
            }
          : null,
      })
    }

    res.json({ sessions })
  } catch (error) {
    console.error("Error fetching student sessions:", error)
    res.status(500).json({ error: "Failed to fetch sessions" })
  }
})

// Get available teachers for a subject
router.get("/teachers", verifyToken, requireRole(["student"]), async (req, res) => {
  try {
    const { subject } = req.query

    let query = db.collection("users").where("role", "==", "teacher")

    if (subject) {
      query = query.where("subjects", "array-contains", subject)
    }

    const teachersSnapshot = await query.get()
    const teachers = []

    teachersSnapshot.forEach((doc) => {
      const teacherData = doc.data()
      teachers.push({
        id: doc.id,
        name: teacherData.name,
        email: teacherData.email,
        subjects: teacherData.subjects,
        availability: teacherData.availability,
        picture: teacherData.picture,
      })
    })

    res.json({ teachers })
  } catch (error) {
    console.error("Error fetching teachers:", error)
    res.status(500).json({ error: "Failed to fetch teachers" })
  }
})

module.exports = router
