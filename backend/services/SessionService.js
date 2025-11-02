const { db } = require("../config/firebase")
const Session = require("../models/Session")

class SessionService {
  // Create a new session
  static async createSession(sessionData) {
    try {
      const sessionId = `session_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`

      const session = new Session({
        id: sessionId,
        ...sessionData,
        meet_link: sessionData.meet_link || null,
        status: sessionData.status || "pending",
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      })

      // Validate session data
      const timeValidation = Session.validateTimeSlot(session.start_time, session.end_time)
      if (!timeValidation.valid) {
        throw new Error(timeValidation.error)
      }

      if (!Session.validateStatus(session.status)) {
        throw new Error("Invalid session status")
      }

      if (!Session.validatePlatform(session.platform)) {
        throw new Error("Invalid platform")
      }

      await db.collection("sessions").doc(sessionId).set(session.toFirestore())
      return session
    } catch (error) {
      console.error("Error creating session:", error)
      throw new Error("Failed to create session")
    }
  }

  // Get session by ID
  static async getSessionById(sessionId) {
    try {
      const doc = await db.collection("sessions").doc(sessionId).get()

      if (!doc.exists) {
        return null
      }

      return Session.fromFirestore(doc)
    } catch (error) {
      console.error("Error fetching session:", error)
      throw new Error("Failed to fetch session")
    }
  }

  // Update session
  static async updateSession(sessionId, updates) {
    try {
      const updateData = {
        ...updates,
        updatedAt: new Date().toISOString(),
      }

      // Validate updates
      if (updates.status && !Session.validateStatus(updates.status)) {
        throw new Error("Invalid session status")
      }

      if (updates.platform && !Session.validatePlatform(updates.platform)) {
        throw new Error("Invalid platform")
      }

      if (updates.start_time && updates.end_time) {
        const timeValidation = Session.validateTimeSlot(updates.start_time, updates.end_time)
        if (!timeValidation.valid) {
          throw new Error(timeValidation.error)
        }
      }

      await db.collection("sessions").doc(sessionId).update(updateData)
      return await this.getSessionById(sessionId)
    } catch (error) {
      console.error("Error updating session:", error)
      throw new Error("Failed to update session")
    }
  }

  // Delete session
  static async deleteSession(sessionId) {
    try {
      await db.collection("sessions").doc(sessionId).delete()
      return true
    } catch (error) {
      console.error("Error deleting session:", error)
      throw new Error("Failed to delete session")
    }
  }

  // Get sessions by user ID
  static async getSessionsByUserId(userId, role, options = {}) {
    try {
      const { status, limit = 10, orderBy = "start_time", order = "desc" } = options

      let query = db.collection("sessions")

      if (role === "student") {
        query = query.where("studentId", "==", userId)
      } else if (role === "teacher") {
        query = query.where("teacherId", "==", userId)
      } else {
        throw new Error("Invalid role")
      }

      if (status) {
        query = query.where("status", "==", status)
      }

      query = query.orderBy(orderBy, order).limit(limit)

      const snapshot = await query.get()
      const sessions = []

      snapshot.forEach((doc) => {
        sessions.push(Session.fromFirestore(doc))
      })

      return sessions
    } catch (error) {
      console.error("Error fetching user sessions:", error)
      throw new Error("Failed to fetch user sessions")
    }
  }

  // Get upcoming sessions (next 7 days)
  static async getUpcomingSessions(userId, role) {
    try {
      const now = new Date()
      const nextWeek = new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000)

      let query = db.collection("sessions")

      if (role === "student") {
        query = query.where("studentId", "==", userId)
      } else if (role === "teacher") {
        query = query.where("teacherId", "==", userId)
      }

      query = query
        .where("start_time", ">=", now.toISOString())
        .where("start_time", "<=", nextWeek.toISOString())
        .where("status", "in", ["pending", "confirmed"])
        .orderBy("start_time", "asc")

      const snapshot = await query.get()
      const sessions = []

      snapshot.forEach((doc) => {
        sessions.push(Session.fromFirestore(doc))
      })

      return sessions
    } catch (error) {
      console.error("Error fetching upcoming sessions:", error)
      throw new Error("Failed to fetch upcoming sessions")
    }
  }

  // Check for session conflicts
  static async hasSessionConflict(userId, startTime, endTime, excludeSessionId = null) {
    try {
      const start = new Date(startTime)
      const end = new Date(endTime)

      // Check as student
      const studentQuery = db
        .collection("sessions")
        .where("studentId", "==", userId)
        .where("status", "in", ["pending", "confirmed"])

      // Check as teacher
      const teacherQuery = db
        .collection("sessions")
        .where("teacherId", "==", userId)
        .where("status", "in", ["pending", "confirmed"])

      const [studentSnapshot, teacherSnapshot] = await Promise.all([studentQuery.get(), teacherQuery.get()])

      const allSessions = [...studentSnapshot.docs, ...teacherSnapshot.docs]

      const hasConflict = allSessions.some((doc) => {
        if (excludeSessionId && doc.id === excludeSessionId) {
          return false
        }

        const session = doc.data()
        const sessionStart = new Date(session.start_time)
        const sessionEnd = new Date(session.end_time)

        // Check for time overlap
        return start < sessionEnd && end > sessionStart
      })

      return hasConflict
    } catch (error) {
      console.error("Error checking session conflict:", error)
      throw new Error("Failed to check session conflict")
    }
  }
}

module.exports = SessionService
