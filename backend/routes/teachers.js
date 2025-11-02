const express = require("express")
const { db } = require("../config/firebase")
const { verifyToken, requireRole } = require("../middleware/auth")
const { validateSubjects, validateTimeSlot } = require("../utils/validation")
const router = express.Router()

// Get teacher profile
router.get("/profile", verifyToken, requireRole(["teacher"]), async (req, res) => {
  try {
    const userDoc = await db.collection("users").doc(req.user.uid).get()

    if (!userDoc.exists) {
      return res.status(404).json({ error: "Teacher profile not found" })
    }

    const userData = userDoc.data()

    res.json({
      teacher: {
        id: userData.id,
        name: userData.name,
        email: userData.email,
        subjects: userData.subjects || [],
        availability: userData.availability || [],
        picture: userData.picture,
        googleCalendarConnected: userData.googleCalendarConnected || false,
        calendlyConnected: userData.calendlyConnected || false,
        createdAt: userData.createdAt,
      },
    })
  } catch (error) {
    console.error("Error fetching teacher profile:", error)
    res.status(500).json({ error: "Failed to fetch teacher profile" })
  }
})

// Update teacher profile
router.put("/profile", verifyToken, requireRole(["teacher"]), async (req, res) => {
  try {
    const { name, subjects } = req.body

    const updates = {}

    if (name) {
      updates.name = name
    }

    if (subjects) {
      const validation = validateSubjects(subjects)
      if (!validation.valid) {
        return res.status(400).json({ error: validation.error, validSubjects: validation.validSubjects })
      }
      updates.subjects = subjects
    }

    if (Object.keys(updates).length === 0) {
      return res.status(400).json({ error: "No valid fields to update" })
    }

    updates.updatedAt = new Date().toISOString()

    await db.collection("users").doc(req.user.uid).update(updates)

    res.json({ message: "Profile updated successfully" })
  } catch (error) {
    console.error("Error updating teacher profile:", error)
    res.status(500).json({ error: "Failed to update profile" })
  }
})

// Add availability slot
router.post("/availability", verifyToken, requireRole(["teacher"]), async (req, res) => {
  try {
    const { startTime, endTime, recurring, dayOfWeek } = req.body

    if (!startTime || !endTime) {
      return res.status(400).json({ error: "Start time and end time are required" })
    }

    const validation = validateTimeSlot(startTime, endTime)
    if (!validation.valid) {
      return res.status(400).json({ error: validation.error })
    }

    const availabilitySlot = {
      id: `slot_${Date.now()}`,
      startTime,
      endTime,
      recurring: recurring || false,
      dayOfWeek: dayOfWeek || null,
      createdAt: new Date().toISOString(),
    }

    // Get current availability
    const userDoc = await db.collection("users").doc(req.user.uid).get()
    const userData = userDoc.data()
    const currentAvailability = userData.availability || []

    // Add new slot
    currentAvailability.push(availabilitySlot)

    await db.collection("users").doc(req.user.uid).update({
      availability: currentAvailability,
      updatedAt: new Date().toISOString(),
    })

    res.status(201).json({
      message: "Availability slot added successfully",
      slot: availabilitySlot,
    })
  } catch (error) {
    console.error("Error adding availability:", error)
    res.status(500).json({ error: "Failed to add availability" })
  }
})

// Remove availability slot
router.delete("/availability/:slotId", verifyToken, requireRole(["teacher"]), async (req, res) => {
  try {
    const { slotId } = req.params

    // Get current availability
    const userDoc = await db.collection("users").doc(req.user.uid).get()
    const userData = userDoc.data()
    const currentAvailability = userData.availability || []

    // Remove the slot
    const updatedAvailability = currentAvailability.filter((slot) => slot.id !== slotId)

    if (updatedAvailability.length === currentAvailability.length) {
      return res.status(404).json({ error: "Availability slot not found" })
    }

    await db.collection("users").doc(req.user.uid).update({
      availability: updatedAvailability,
      updatedAt: new Date().toISOString(),
    })

    res.json({ message: "Availability slot removed successfully" })
  } catch (error) {
    console.error("Error removing availability:", error)
    res.status(500).json({ error: "Failed to remove availability" })
  }
})

// Get teacher's sessions
router.get("/sessions", verifyToken, requireRole(["teacher"]), async (req, res) => {
  try {
    const sessionsSnapshot = await db
      .collection("sessions")
      .where("teacherId", "==", req.user.uid)
      .orderBy("start_time", "desc")
      .get()

    const sessions = []
    for (const doc of sessionsSnapshot.docs) {
      const sessionData = doc.data()

      // Get student information
      const studentDoc = await db.collection("users").doc(sessionData.studentId).get()
      const studentData = studentDoc.exists ? studentDoc.data() : null

      sessions.push({
        id: doc.id,
        ...sessionData,
        student: studentData
          ? {
              name: studentData.name,
              email: studentData.email,
            }
          : null,
      })
    }

    res.json({ sessions })
  } catch (error) {
    console.error("Error fetching teacher sessions:", error)
    res.status(500).json({ error: "Failed to fetch sessions" })
  }
})

// Update session status (confirm/cancel)
router.patch("/sessions/:sessionId", verifyToken, requireRole(["teacher"]), async (req, res) => {
  try {
    const { sessionId } = req.params
    const { status } = req.body

    if (!["confirmed", "cancelled"].includes(status)) {
      return res.status(400).json({ error: "Status must be 'confirmed' or 'cancelled'" })
    }

    const sessionDoc = await db.collection("sessions").doc(sessionId).get()

    if (!sessionDoc.exists) {
      return res.status(404).json({ error: "Session not found" })
    }

    const sessionData = sessionDoc.data()

    // Verify the teacher owns this session
    if (sessionData.teacherId !== req.user.uid) {
      return res.status(403).json({ error: "You can only update your own sessions" })
    }

    await db.collection("sessions").doc(sessionId).update({
      status,
      updatedAt: new Date().toISOString(),
    })

    res.json({ message: `Session ${status} successfully` })
  } catch (error) {
    console.error("Error updating session:", error)
    res.status(500).json({ error: "Failed to update session" })
  }
})

module.exports = router
