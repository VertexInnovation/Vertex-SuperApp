const { db } = require("../config/firebase")

// Initialize Firestore collections with proper structure and indexes
async function initializeFirestoreSchema() {
  try {
    console.log("Initializing Firestore schema...")

    // Create sample data to establish collection structure

    // Users collection structure
    const sampleUser = {
      id: "sample_user_id",
      name: "Sample User",
      email: "sample@example.com",
      role: "student", // or "teacher"
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      // Teacher-specific fields (only if role === "teacher")
      subjects: [], // array of subjects
      availability: [], // array of time slots
      googleCalendarConnected: false,
      calendlyConnected: false,
      // Optional fields
      picture: null,
      googleConnected: false,
    }

    // Sessions collection structure
    const sampleSession = {
      id: "sample_session_id",
      studentId: "student_user_id",
      teacherId: "teacher_user_id",
      subject: "mathematics",
      start_time: new Date().toISOString(),
      end_time: new Date(Date.now() + 60 * 60 * 1000).toISOString(), // 1 hour later
      platform: "google", // "google" or "calendly"
      meet_link: "https://meet.google.com/xxx-xxxx-xxx",
      status: "pending", // "pending", "confirmed", "completed", "cancelled"
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      // Optional fields
      calendarEventId: null,
      calendlyEventId: null,
      notes: "",
    }

    // Create collections with sample documents (will be deleted after)
    await db.collection("users").doc("sample_user").set(sampleUser)
    await db.collection("sessions").doc("sample_session").set(sampleSession)

    console.log("✅ Collections created successfully")

    // Delete sample documents
    await db.collection("users").doc("sample_user").delete()
    await db.collection("sessions").doc("sample_session").delete()

    console.log("✅ Sample documents cleaned up")

    // Note: Firestore indexes are typically created through the Firebase Console
    // or using the Firebase CLI with firestore.indexes.json
    console.log("📝 Remember to create the following indexes in Firebase Console:")
    console.log("   - users: role (ascending)")
    console.log("   - users: subjects (array-contains)")
    console.log("   - sessions: studentId (ascending), start_time (descending)")
    console.log("   - sessions: teacherId (ascending), start_time (descending)")
    console.log("   - sessions: status (ascending), start_time (ascending)")

    console.log("🎉 Firestore schema initialization completed!")
  } catch (error) {
    console.error("❌ Error initializing Firestore schema:", error)
    throw error
  }
}

// Run the initialization
if (require.main === module) {
  initializeFirestoreSchema()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error)
      process.exit(1)
    })
}

module.exports = { initializeFirestoreSchema }
