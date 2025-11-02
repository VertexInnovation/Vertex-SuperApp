# Tutoring Application Backend

A comprehensive Node.js/Express backend for a tutoring application with Firebase integration, Google Calendar, and Calendly support.

## Features

### Authentication & Authorization
- **Firebase Auth Integration**: Secure JWT-based authentication
- **Role-based Access Control**: Separate permissions for students and teachers
- **Google OAuth**: Teachers must use Google login for calendar integration
- **Email/Password**: Students can use traditional email/password authentication

### User Management
- **Student Profiles**: Basic profile management and session tracking
- **Teacher Profiles**: Subject management, availability scheduling, and platform connections
- **Role Validation**: Strict role-based feature access

### Session Booking System
- **Flexible Booking**: Support for both Google Calendar and Calendly platforms
- **Availability Checking**: Real-time teacher availability validation
- **Conflict Detection**: Prevents double-booking and scheduling conflicts
- **Session Management**: Full CRUD operations for tutoring sessions

### Google Calendar Integration
- **OAuth 2.0 Flow**: Secure Google Calendar connection for teachers
- **Automatic Event Creation**: Creates calendar events with Google Meet links
- **Real-time Sync**: Updates and cancellations sync with Google Calendar
- **Token Management**: Automatic token refresh and error handling

### Calendly Integration
- **OAuth Integration**: Connect teacher Calendly accounts
- **Event Type Management**: Access to teacher's available meeting types
- **Booking Creation**: Direct booking through Calendly API
- **Webhook Support**: Real-time updates from Calendly events

### Security Features
- **Rate Limiting**: Configurable rate limits for different endpoints
- **Input Validation**: Comprehensive request validation using express-validator
- **Security Headers**: CORS, CSP, and other security headers
- **Request Sanitization**: XSS protection and input cleaning
- **Session Management**: Token expiration and session timeout handling

### Monitoring & Logging
- **Error Tracking**: Comprehensive error logging to Firestore
- **Performance Monitoring**: Request duration and slow query detection
- **Security Event Logging**: Unauthorized access and suspicious activity tracking
- **API Usage Analytics**: Track endpoint usage and user behavior

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user (students: email/password, teachers: Google only)
- `POST /api/auth/login` - Login with email/password (students only)
- `POST /api/auth/google/callback` - Handle Google OAuth callback
- `GET /api/auth/profile` - Get current user profile
- `POST /api/auth/logout` - Logout user

### Students
- `GET /api/students/profile` - Get student profile
- `PUT /api/students/profile` - Update student profile
- `GET /api/students/sessions` - Get student's booked sessions
- `GET /api/students/teachers` - Find available teachers by subject

### Teachers
- `GET /api/teachers/profile` - Get teacher profile
- `PUT /api/teachers/profile` - Update teacher profile and subjects
- `POST /api/teachers/availability` - Add availability time slot
- `DELETE /api/teachers/availability/:slotId` - Remove availability slot
- `GET /api/teachers/sessions` - Get teacher's sessions
- `PATCH /api/teachers/sessions/:sessionId` - Update session status

### Sessions
- `POST /api/sessions/book` - Book a new tutoring session
- `GET /api/sessions/:sessionId` - Get session details
- `PATCH /api/sessions/:sessionId` - Update session (reschedule, add notes)
- `DELETE /api/sessions/:sessionId` - Cancel session
- `GET /api/sessions/teachers/:teacherId/availability` - Check teacher availability
- `GET /api/sessions` - Get user's sessions with filtering

### Google Calendar
- `GET /api/calendar/connect` - Get Google Calendar OAuth URL
- `POST /api/calendar/callback` - Handle Google Calendar OAuth callback
- `DELETE /api/calendar/disconnect` - Disconnect Google Calendar
- `GET /api/calendar/events` - Get teacher's calendar events
- `POST /api/calendar/check-availability` - Check availability for time slot
- `GET /api/calendar/status` - Get calendar connection status

### Calendly
- `GET /api/calendly/connect` - Get Calendly OAuth URL
- `POST /api/calendly/callback` - Handle Calendly OAuth callback
- `DELETE /api/calendly/disconnect` - Disconnect Calendly
- `GET /api/calendly/event-types` - Get teacher's Calendly event types
- `GET /api/calendly/available-times` - Get available times for event type
- `GET /api/calendly/status` - Get Calendly connection status
- `GET /api/calendly/user` - Get Calendly user information
- `POST /api/calendly/webhook` - Handle Calendly webhooks

## Environment Variables

\`\`\`env
# Server Configuration
PORT=3000
NODE_ENV=development
FRONTEND_URL=http://localhost:3000

# Firebase Configuration
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_PRIVATE_KEY_ID=your-private-key-id
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nYOUR_PRIVATE_KEY\n-----END PRIVATE KEY-----\n"
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@your-project-id.iam.gserviceaccount.com
FIREBASE_CLIENT_ID=your-client-id

# Google Calendar API
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
GOOGLE_REDIRECT_URI=http://localhost:3000/auth/google/callback

# Calendly API
CALENDLY_CLIENT_ID=your-calendly-client-id
CALENDLY_CLIENT_SECRET=your-calendly-client-secret
CALENDLY_REDIRECT_URI=http://localhost:3000/auth/calendly/callback
\`\`\`

## Installation & Setup

1. **Clone and Install**
   \`\`\`bash
   npm install
   \`\`\`

2. **Environment Setup**
   - Copy `.env.example` to `.env`
   - Fill in your Firebase, Google, and Calendly credentials

3. **Firebase Setup**
   - Create a Firebase project
   - Enable Authentication and Firestore
   - Download service account key
   - Run the database initialization script:
     \`\`\`bash
     node scripts/init-firestore-schema.js
     \`\`\`

4. **Google Calendar Setup**
   - Create Google Cloud Project
   - Enable Calendar API
   - Create OAuth 2.0 credentials
   - Add authorized redirect URIs

5. **Calendly Setup**
   - Create Calendly developer account
   - Register your application
   - Get client credentials

6. **Start Development Server**
   \`\`\`bash
   npm run dev
   \`\`\`

## Database Schema

### Users Collection
\`\`\`javascript
{
  id: "user_id",
  name: "User Name",
  email: "user@example.com",
  role: "student" | "teacher",
  createdAt: "2024-01-01T00:00:00.000Z",
  updatedAt: "2024-01-01T00:00:00.000Z",
  
  // Teacher-specific fields
  subjects: ["mathematics", "physics"],
  availability: [
    {
      id: "slot_id",
      startTime: "2024-01-01T09:00:00.000Z",
      endTime: "2024-01-01T17:00:00.000Z",
      recurring: false,
      dayOfWeek: null
    }
  ],
  googleCalendarConnected: false,
  calendlyConnected: false,
  
  // OAuth tokens (encrypted in production)
  googleCalendarTokens: { /* OAuth tokens */ },
  calendlyTokens: { /* OAuth tokens */ }
}
\`\`\`

### Sessions Collection
\`\`\`javascript
{
  id: "session_id",
  studentId: "student_user_id",
  teacherId: "teacher_user_id",
  subject: "mathematics",
  start_time: "2024-01-01T10:00:00.000Z",
  end_time: "2024-01-01T11:00:00.000Z",
  platform: "google" | "calendly",
  meet_link: "https://meet.google.com/xxx-xxxx-xxx",
  status: "pending" | "confirmed" | "completed" | "cancelled",
  notes: "Session notes",
  createdAt: "2024-01-01T00:00:00.000Z",
  updatedAt: "2024-01-01T00:00:00.000Z",
  
  // Platform-specific IDs
  calendarEventId: "google_event_id",
  calendlyEventId: "calendly_event_id",
  calendlyEventUri: "calendly_event_uri"
}
\`\`\`

## Security Considerations

- **JWT Validation**: All protected routes verify Firebase JWT tokens
- **Role-based Access**: Strict role checking for sensitive operations
- **Rate Limiting**: Prevents abuse with configurable rate limits
- **Input Validation**: All inputs validated and sanitized
- **CORS Configuration**: Restricted to allowed origins
- **Security Headers**: Comprehensive security headers applied
- **Error Handling**: Secure error responses without information leakage
- **Logging**: Comprehensive security event logging

## Monitoring & Analytics

The application includes built-in monitoring for:
- **Error Tracking**: All errors logged to Firestore with context
- **Performance Monitoring**: Slow queries and request duration tracking
- **Security Events**: Unauthorized access attempts and suspicious activity
- **API Usage**: Endpoint usage statistics and user behavior analytics

## Testing

\`\`\`bash
# Run tests
npm test

# Run with coverage
npm run test:coverage
\`\`\`

## Deployment

The application is designed for deployment on platforms like:
- **Vercel**: Serverless deployment with automatic scaling
- **Google Cloud Run**: Containerized deployment with Firebase integration
- **AWS Lambda**: Serverless deployment with API Gateway
- **Traditional VPS**: Docker-based deployment

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request
