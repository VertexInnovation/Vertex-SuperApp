const { db } = require("../config/firebase")
const User = require("../models/User")

class UserService {
  // Create a new user
  static async createUser(userData) {
    try {
      const user = new User({
        ...userData,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      })

      await db.collection("users").doc(user.id).set(user.toFirestore())
      return user
    } catch (error) {
      console.error("Error creating user:", error)
      throw new Error("Failed to create user")
    }
  }

  // Get user by ID
  static async getUserById(userId) {
    try {
      const doc = await db.collection("users").doc(userId).get()

      if (!doc.exists) {
        return null
      }

      return User.fromFirestore(doc)
    } catch (error) {
      console.error("Error fetching user:", error)
      throw new Error("Failed to fetch user")
    }
  }

  // Update user
  static async updateUser(userId, updates) {
    try {
      const updateData = {
        ...updates,
        updatedAt: new Date().toISOString(),
      }

      await db.collection("users").doc(userId).update(updateData)
      return await this.getUserById(userId)
    } catch (error) {
      console.error("Error updating user:", error)
      throw new Error("Failed to update user")
    }
  }

  // Get teachers by subject
  static async getTeachersBySubject(subject) {
    try {
      let query = db.collection("users").where("role", "==", "teacher")

      if (subject) {
        query = query.where("subjects", "array-contains", subject)
      }

      const snapshot = await query.get()
      const teachers = []

      snapshot.forEach((doc) => {
        teachers.push(User.fromFirestore(doc))
      })

      return teachers
    } catch (error) {
      console.error("Error fetching teachers:", error)
      throw new Error("Failed to fetch teachers")
    }
  }

  // Add availability slot for teacher
  static async addAvailabilitySlot(teacherId, slot) {
    try {
      const user = await this.getUserById(teacherId)

      if (!user || user.role !== "teacher") {
        throw new Error("User is not a teacher")
      }

      const availabilitySlot = {
        id: `slot_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
        ...slot,
        createdAt: new Date().toISOString(),
      }

      const updatedAvailability = [...user.availability, availabilitySlot]

      await db.collection("users").doc(teacherId).update({
        availability: updatedAvailability,
        updatedAt: new Date().toISOString(),
      })

      return availabilitySlot
    } catch (error) {
      console.error("Error adding availability slot:", error)
      throw new Error("Failed to add availability slot")
    }
  }

  // Remove availability slot for teacher
  static async removeAvailabilitySlot(teacherId, slotId) {
    try {
      const user = await this.getUserById(teacherId)

      if (!user || user.role !== "teacher") {
        throw new Error("User is not a teacher")
      }

      const updatedAvailability = user.availability.filter((slot) => slot.id !== slotId)

      if (updatedAvailability.length === user.availability.length) {
        throw new Error("Availability slot not found")
      }

      await db.collection("users").doc(teacherId).update({
        availability: updatedAvailability,
        updatedAt: new Date().toISOString(),
      })

      return true
    } catch (error) {
      console.error("Error removing availability slot:", error)
      throw new Error("Failed to remove availability slot")
    }
  }

  // Check if teacher is available at a specific time
  static async isTeacherAvailable(teacherId, startTime, endTime) {
    try {
      const user = await this.getUserById(teacherId)

      if (!user || user.role !== "teacher") {
        return false
      }

      const requestStart = new Date(startTime)
      const requestEnd = new Date(endTime)

      // Check availability slots
      const hasAvailableSlot = user.availability.some((slot) => {
        const slotStart = new Date(slot.startTime)
        const slotEnd = new Date(slot.endTime)

        return requestStart >= slotStart && requestEnd <= slotEnd
      })

      if (!hasAvailableSlot) {
        return false
      }

      // Check for conflicting sessions
      const sessionsSnapshot = await db
        .collection("sessions")
        .where("teacherId", "==", teacherId)
        .where("status", "in", ["pending", "confirmed"])
        .get()

      const hasConflict = sessionsSnapshot.docs.some((doc) => {
        const session = doc.data()
        const sessionStart = new Date(session.start_time)
        const sessionEnd = new Date(session.end_time)

        // Check for time overlap
        return requestStart < sessionEnd && requestEnd > sessionStart
      })

      return !hasConflict
    } catch (error) {
      console.error("Error checking teacher availability:", error)
      throw new Error("Failed to check teacher availability")
    }
  }
}

module.exports = UserService
