class Session {
  constructor(data) {
    this.id = data.id
    this.studentId = data.studentId
    this.teacherId = data.teacherId
    this.subject = data.subject
    this.start_time = data.start_time
    this.end_time = data.end_time
    this.platform = data.platform // "google" or "calendly"
    this.meet_link = data.meet_link
    this.status = data.status // "pending", "confirmed", "completed", "cancelled"
    this.createdAt = data.createdAt
    this.updatedAt = data.updatedAt
    this.calendarEventId = data.calendarEventId || null
    this.calendlyEventId = data.calendlyEventId || null
    this.notes = data.notes || ""
  }

  // Validation methods
  static validateStatus(status) {
    return ["pending", "confirmed", "completed", "cancelled"].includes(status)
  }

  static validatePlatform(platform) {
    return ["google", "calendly"].includes(platform)
  }

  static validateTimeSlot(startTime, endTime) {
    const start = new Date(startTime)
    const end = new Date(endTime)

    if (isNaN(start.getTime()) || isNaN(end.getTime())) {
      return { valid: false, error: "Invalid date format" }
    }

    if (start >= end) {
      return { valid: false, error: "Start time must be before end time" }
    }

    if (start < new Date()) {
      return { valid: false, error: "Cannot schedule sessions in the past" }
    }

    // Session should be at least 30 minutes
    const duration = (end - start) / (1000 * 60) // minutes
    if (duration < 30) {
      return { valid: false, error: "Session must be at least 30 minutes long" }
    }

    // Session should not be longer than 4 hours
    if (duration > 240) {
      return { valid: false, error: "Session cannot be longer than 4 hours" }
    }

    return { valid: true }
  }

  // Convert to Firestore document
  toFirestore() {
    return {
      id: this.id,
      studentId: this.studentId,
      teacherId: this.teacherId,
      subject: this.subject,
      start_time: this.start_time,
      end_time: this.end_time,
      platform: this.platform,
      meet_link: this.meet_link,
      status: this.status,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      calendarEventId: this.calendarEventId,
      calendlyEventId: this.calendlyEventId,
      notes: this.notes,
    }
  }

  // Create from Firestore document
  static fromFirestore(doc) {
    const data = doc.data()
    return new Session({ id: doc.id, ...data })
  }

  // Calculate session duration in minutes
  getDuration() {
    const start = new Date(this.start_time)
    const end = new Date(this.end_time)
    return (end - start) / (1000 * 60)
  }

  // Check if session is in the past
  isPast() {
    return new Date(this.end_time) < new Date()
  }

  // Check if session is upcoming (within next 24 hours)
  isUpcoming() {
    const now = new Date()
    const sessionStart = new Date(this.start_time)
    const timeDiff = sessionStart - now
    return timeDiff > 0 && timeDiff <= 24 * 60 * 60 * 1000 // 24 hours in milliseconds
  }
}

module.exports = Session
