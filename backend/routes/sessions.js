const express = require("express")
const { db } = require("../config/firebase")
const { verifyToken, requireRole } = require("../middleware/auth")
const SessionService = require("../services/SessionService")
const UserService = require("../services/UserService")
const GoogleCalendarService = require("../services/GoogleCalendarService")
const CalendlyService = require("../services/CalendlyService")
const { validateTimeSlot } = require("../utils/validation")
const router = express.Router()

// Book a new session (students only)
router.post("/book", verifyToken, requireRole(["student"]), async (req, res) => {
  try {
    const { teacherId, subject, startTime, endTime, platform = "google", notes = "", eventTypeUri } = req.body

    // Validation
    if (!teacherId || !subject || !startTime || !endTime) {
      return res.status(400).json({
        error: "Teacher ID, subject, start time, and end time are required",
      })
    }

    const timeValidation = validateTimeSlot(startTime, endTime)
    if (!timeValidation.valid) {
      return res.status(400).json({ error: timeValidation.error })
    }

    if (!["google", "calendly"].includes(platform)) {
      return res.status(400).json({ error: "Platform must be 'google' or 'calendly'" })
    }

    // For Calendly bookings, eventTypeUri is required
    if (platform === "calendly" && !eventTypeUri) {
      return res.status(400).json({ error: "Event type URI is required for Calendly bookings" })
    }

    // Check if teacher exists and teaches the subject
    const teacher = await UserService.getUserById(teacherId)
    if (!teacher || teacher.role !== "teacher") {
      return res.status(404).json({ error: "Teacher not found" })
    }

    if (!teacher.subjects.includes(subject)) {
      return res.status(400).json({
        error: `Teacher does not teach ${subject}`,
        availableSubjects: teacher.subjects,
      })
    }

    // Check teacher availability
    const isAvailable = await UserService.isTeacherAvailable(teacherId, startTime, endTime)
    if (!isAvailable) {
      return res.status(409).json({
        error: "Teacher is not available at the requested time",
      })
    }

    // Get student information
    const student = await UserService.getUserById(req.user.uid)
    if (!student) {
      return res.status(404).json({ error: "Student profile not found" })
    }

    // Create session
    const sessionData = {
      studentId: req.user.uid,
      teacherId,
      subject,
      start_time: startTime,
      end_time: endTime,
      platform,
      status: "pending",
      notes,
    }

    const session = await SessionService.createSession(sessionData)

    // Handle platform-specific booking
    if (platform === "google" && teacher.googleCalendarConnected) {
      try {
        const calendarService = new GoogleCalendarService()

        const calendarEvent = await calendarService.createTutoringEvent({
          sessionId: session.id,
          teacherId: teacher.id,
          teacherName: teacher.name,
          teacherEmail: teacher.email,
          studentName: student.name,
          studentEmail: student.email,
          subject: session.subject,
          startTime: session.start_time,
          endTime: session.end_time,
          notes: session.notes,
        })

        // Update session with calendar event details
        await SessionService.updateSession(session.id, {
          calendarEventId: calendarEvent.eventId,
          meet_link: calendarEvent.meetLink,
        })

        session.calendarEventId = calendarEvent.eventId
        session.meet_link = calendarEvent.meetLink
      } catch (calendarError) {
        console.error("Calendar creation error:", calendarError)
        // Session is still created, but calendar event failed
      }
    } else if (platform === "calendly" && teacher.calendlyConnected) {
      try {
        const calendlyService = new CalendlyService()

        const calendlyEvent = await calendlyService.createScheduledEvent(teacherId, eventTypeUri, startTime, {
          email: student.email,
          name: student.name,
        })

        // Update session with Calendly event details
        await SessionService.updateSession(session.id, {
          calendlyEventId: calendlyEvent.uuid,
          calendlyEventUri: calendlyEvent.uri,
          meet_link: calendlyEvent.location?.join_url || null,
        })

        session.calendlyEventId = calendlyEvent.uuid
        session.calendlyEventUri = calendlyEvent.uri
        session.meet_link = calendlyEvent.location?.join_url || null
      } catch (calendlyError) {
        console.error("Calendly creation error:", calendlyError)
        // Session is still created, but Calendly event failed
      }
    }

    res.status(201).json({
      message: "Session booked successfully",
      session: {
        id: session.id,
        teacherId: session.teacherId,
        teacherName: teacher.name,
        subject: session.subject,
        start_time: session.start_time,
        end_time: session.end_time,
        platform: session.platform,
        status: session.status,
        meet_link: session.meet_link,
      },
    })
  } catch (error) {
    console.error("Session booking error:", error)
    res.status(500).json({ error: "Failed to book session" })
  }
})

// Get session details
router.get("/:sessionId", verifyToken, async (req, res) => {
  try {
    const { sessionId } = req.params

    const session = await SessionService.getSessionById(sessionId)
    if (!session) {
      return res.status(404).json({ error: "Session not found" })
    }

    // Check if user has access to this session
    if (session.studentId !== req.user.uid && session.teacherId !== req.user.uid) {
      return res.status(403).json({ error: "Access denied" })
    }

    // Get additional user information
    const [student, teacher] = await Promise.all([
      UserService.getUserById(session.studentId),
      UserService.getUserById(session.teacherId),
    ])

    res.json({
      session: {
        ...session.toFirestore(),
        student: student
          ? {
              id: student.id,
              name: student.name,
              email: student.email,
            }
          : null,
        teacher: teacher
          ? {
              id: teacher.id,
              name: teacher.name,
              email: teacher.email,
              subjects: teacher.subjects,
            }
          : null,
      },
    })
  } catch (error) {
    console.error("Error fetching session:", error)
    res.status(500).json({ error: "Failed to fetch session" })
  }
})

// Update session (for status changes, rescheduling, etc.)
router.patch("/:sessionId", verifyToken, async (req, res) => {
  try {
    const { sessionId } = req.params
    const { status, startTime, endTime, notes } = req.body

    const session = await SessionService.getSessionById(sessionId)
    if (!session) {
      return res.status(404).json({ error: "Session not found" })
    }

    // Check permissions
    const isStudent = session.studentId === req.user.uid
    const isTeacher = session.teacherId === req.user.uid

    if (!isStudent && !isTeacher) {
      return res.status(403).json({ error: "Access denied" })
    }

    const updates = {}

    // Status updates
    if (status) {
      if (!["pending", "confirmed", "completed", "cancelled"].includes(status)) {
        return res.status(400).json({ error: "Invalid status" })
      }

      // Only teachers can confirm sessions
      if (status === "confirmed" && !isTeacher) {
        return res.status(403).json({ error: "Only teachers can confirm sessions" })
      }

      // Only allow certain status transitions
      const validTransitions = {
        pending: ["confirmed", "cancelled"],
        confirmed: ["completed", "cancelled"],
        completed: [], // Cannot change from completed
        cancelled: [], // Cannot change from cancelled
      }

      if (!validTransitions[session.status].includes(status)) {
        return res.status(400).json({
          error: `Cannot change status from ${session.status} to ${status}`,
        })
      }

      updates.status = status
    }

    // Rescheduling (only if session is pending)
    if ((startTime || endTime) && session.status !== "pending") {
      return res.status(400).json({
        error: "Can only reschedule pending sessions",
      })
    }

    if (startTime && endTime) {
      const timeValidation = validateTimeSlot(startTime, endTime)
      if (!timeValidation.valid) {
        return res.status(400).json({ error: timeValidation.error })
      }

      // Check teacher availability for new time
      const isAvailable = await UserService.isTeacherAvailable(session.teacherId, startTime, endTime)
      if (!isAvailable) {
        return res.status(409).json({
          error: "Teacher is not available at the requested time",
        })
      }

      updates.start_time = startTime
      updates.end_time = endTime
    }

    // Notes update
    if (notes !== undefined) {
      updates.notes = notes
    }

    if (Object.keys(updates).length === 0) {
      return res.status(400).json({ error: "No valid updates provided" })
    }

    const updatedSession = await SessionService.updateSession(sessionId, updates)

    // Enhanced calendar event cancellation
    if (
      session.platform === "google" &&
      session.calendarEventId &&
      session.calendarEventId !== "pending_calendar_creation"
    ) {
      try {
        const calendarService = new GoogleCalendarService()

        const calendarUpdates = {}
        if (updates.start_time && updates.end_time) {
          calendarUpdates.startTime = updates.start_time
          calendarUpdates.endTime = updates.end_time
        }
        if (updates.notes) {
          calendarUpdates.notes = updates.notes
        }
        if (updates.status === "cancelled") {
          calendarUpdates.status = "cancelled"
        }

        if (Object.keys(calendarUpdates).length > 0) {
          await calendarService.updateTutoringEvent(session.teacherId, session.calendarEventId, calendarUpdates)
        }
      } catch (calendarError) {
        console.error("Calendar update error:", calendarError)
        // Continue even if calendar update fails
      }
    } else if (session.platform === "calendly" && session.calendlyEventUri) {
      try {
        const calendlyService = new CalendlyService()

        const calendlyUpdates = {}
        if (updates.start_time && updates.end_time) {
          calendlyUpdates.startTime = updates.start_time
          calendlyUpdates.endTime = updates.end_time
        }
        if (updates.notes) {
          calendlyUpdates.notes = updates.notes
        }
        if (updates.status === "cancelled") {
          calendlyUpdates.status = "cancelled"
        }

        if (Object.keys(calendlyUpdates).length > 0) {
          await calendlyService.updateScheduledEvent(session.teacherId, session.calendlyEventUri, calendlyUpdates)
        }
      } catch (calendlyError) {
        console.error("Calendly update error:", calendlyError)
        // Continue even if Calendly update fails
      }
    }

    res.json({
      message: "Session updated successfully",
      session: updatedSession.toFirestore(),
    })
  } catch (error) {
    console.error("Error updating session:", error)
    res.status(500).json({ error: "Failed to update session" })
  }
})

// Cancel session
router.delete("/:sessionId", verifyToken, async (req, res) => {
  try {
    const { sessionId } = req.params

    const session = await SessionService.getSessionById(sessionId)
    if (!session) {
      return res.status(404).json({ error: "Session not found" })
    }

    // Check permissions
    const isStudent = session.studentId === req.user.uid
    const isTeacher = session.teacherId === req.user.uid

    if (!isStudent && !isTeacher) {
      return res.status(403).json({ error: "Access denied" })
    }

    // Cannot cancel completed sessions
    if (session.status === "completed") {
      return res.status(400).json({ error: "Cannot cancel completed sessions" })
    }

    // Update session status to cancelled
    await SessionService.updateSession(sessionId, { status: "cancelled" })

    // Handle platform-specific cancellation
    if (
      session.platform === "google" &&
      session.calendarEventId &&
      session.calendarEventId !== "pending_calendar_creation"
    ) {
      try {
        const calendarService = new GoogleCalendarService()
        await calendarService.cancelTutoringEvent(session.teacherId, session.calendarEventId)
      } catch (calendarError) {
        console.error("Calendar cancellation error:", calendarError)
      }
    } else if (session.platform === "calendly" && session.calendlyEventUri) {
      try {
        const calendlyService = new CalendlyService()
        await calendlyService.cancelScheduledEvent(
          session.teacherId,
          session.calendlyEventUri,
          "Session cancelled by user",
        )
      } catch (calendlyError) {
        console.error("Calendly cancellation error:", calendlyError)
      }
    }

    res.json({ message: "Session cancelled successfully" })
  } catch (error) {
    console.error("Error cancelling session:", error)
    res.status(500).json({ error: "Failed to cancel session" })
  }
})

// Get available time slots for a teacher
router.get("/teachers/:teacherId/availability", verifyToken, async (req, res) => {
  try {
    const { teacherId } = req.params
    const { date, subject } = req.query

    const teacher = await UserService.getUserById(teacherId)
    if (!teacher || teacher.role !== "teacher") {
      return res.status(404).json({ error: "Teacher not found" })
    }

    if (subject && !teacher.subjects.includes(subject)) {
      return res.status(400).json({
        error: `Teacher does not teach ${subject}`,
        availableSubjects: teacher.subjects,
      })
    }

    // Get teacher's availability slots
    let availableSlots = teacher.availability

    // Filter by date if provided
    if (date) {
      const targetDate = new Date(date)
      availableSlots = availableSlots.filter((slot) => {
        const slotDate = new Date(slot.startTime)
        return slotDate.toDateString() === targetDate.toDateString()
      })
    }

    // Get existing sessions to filter out booked slots
    const sessionsSnapshot = await db
      .collection("sessions")
      .where("teacherId", "==", teacherId)
      .where("status", "in", ["pending", "confirmed"])
      .get()

    const bookedSlots = sessionsSnapshot.docs.map((doc) => {
      const session = doc.data()
      return {
        start: new Date(session.start_time),
        end: new Date(session.end_time),
      }
    })

    // Filter out conflicting slots
    const freeSlots = availableSlots.filter((slot) => {
      const slotStart = new Date(slot.startTime)
      const slotEnd = new Date(slot.endTime)

      return !bookedSlots.some((booked) => {
        return slotStart < booked.end && slotEnd > booked.start
      })
    })

    res.json({
      teacherId,
      teacherName: teacher.name,
      subjects: teacher.subjects,
      availableSlots: freeSlots,
      totalSlots: availableSlots.length,
      freeSlots: freeSlots.length,
    })
  } catch (error) {
    console.error("Error fetching teacher availability:", error)
    res.status(500).json({ error: "Failed to fetch teacher availability" })
  }
})

// Get upcoming sessions for current user
router.get("/", verifyToken, async (req, res) => {
  try {
    const { status, limit = 10 } = req.query

    let query = db.collection("sessions")

    // Filter by user role
    const userDoc = await db.collection("users").doc(req.user.uid).get()
    const userData = userDoc.data()

    if (userData.role === "student") {
      query = query.where("studentId", "==", req.user.uid)
    } else if (userData.role === "teacher") {
      query = query.where("teacherId", "==", req.user.uid)
    }

    // Filter by status if provided
    if (status && ["pending", "confirmed", "completed", "cancelled"].includes(status)) {
      query = query.where("status", "==", status)
    }

    // Order by start time
    query = query.orderBy("start_time", "desc").limit(Number.parseInt(limit))

    const snapshot = await query.get()
    const sessions = []

    for (const doc of snapshot.docs) {
      const sessionData = doc.data()

      // Get the other user's information
      const otherUserId = userData.role === "student" ? sessionData.teacherId : sessionData.studentId
      const otherUser = await UserService.getUserById(otherUserId)

      sessions.push({
        id: doc.id,
        ...sessionData,
        [userData.role === "student" ? "teacher" : "student"]: otherUser
          ? {
              id: otherUser.id,
              name: otherUser.name,
              email: otherUser.email,
              ...(otherUser.role === "teacher" ? { subjects: otherUser.subjects } : {}),
            }
          : null,
      })
    }

    res.json({ sessions })
  } catch (error) {
    console.error("Error fetching sessions:", error)
    res.status(500).json({ error: "Failed to fetch sessions" })
  }
})

module.exports = router
