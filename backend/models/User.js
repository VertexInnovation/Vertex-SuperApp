class User {
  constructor(data) {
    this.id = data.id
    this.name = data.name
    this.email = data.email
    this.role = data.role
    this.createdAt = data.createdAt
    this.updatedAt = data.updatedAt
    this.picture = data.picture || null
    this.googleConnected = data.googleConnected || false

    // Teacher-specific properties
    if (this.role === "teacher") {
      this.subjects = data.subjects || []
      this.availability = data.availability || []
      this.googleCalendarConnected = data.googleCalendarConnected || false
      this.calendlyConnected = data.calendlyConnected || false
    }
  }

  // Validation methods
  static validateRole(role) {
    return ["student", "teacher"].includes(role)
  }

  static validateSubjects(subjects) {
    const validSubjects = [
      "mathematics",
      "physics",
      "chemistry",
      "biology",
      "english",
      "history",
      "geography",
      "computer-science",
      "economics",
      "psychology",
      "art",
      "music",
      "languages",
      "business",
      "philosophy",
    ]

    if (!Array.isArray(subjects)) {
      return { valid: false, error: "Subjects must be an array" }
    }

    const invalidSubjects = subjects.filter((subject) => !validSubjects.includes(subject))

    if (invalidSubjects.length > 0) {
      return {
        valid: false,
        error: `Invalid subjects: ${invalidSubjects.join(", ")}`,
        validSubjects,
      }
    }

    return { valid: true }
  }

  // Convert to Firestore document
  toFirestore() {
    const data = {
      id: this.id,
      name: this.name,
      email: this.email,
      role: this.role,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      picture: this.picture,
      googleConnected: this.googleConnected,
    }

    if (this.role === "teacher") {
      data.subjects = this.subjects
      data.availability = this.availability
      data.googleCalendarConnected = this.googleCalendarConnected
      data.calendlyConnected = this.calendlyConnected
    }

    return data
  }

  // Create from Firestore document
  static fromFirestore(doc) {
    const data = doc.data()
    return new User({ id: doc.id, ...data })
  }
}

module.exports = User
