const validateEmail = (email) => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return emailRegex.test(email)
}

const validateTimeSlot = (startTime, endTime) => {
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

  return { valid: true }
}

const validateSubjects = (subjects) => {
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

module.exports = {
  validateEmail,
  validateTimeSlot,
  validateSubjects,
}
