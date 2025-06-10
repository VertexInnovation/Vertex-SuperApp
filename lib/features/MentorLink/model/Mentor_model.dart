import 'package:flutter/material.dart';

// Mentor model
class Mentor {
  final String id;
  final String name;
  final String title;
  final String company;
  final double rating;
  final String experience;
  final List<String> skills;
  final String availability;
  final bool isVerified;
  final String profileImage;
  final bool isOnline;

  Mentor({
    required this.id,
    required this.name,
    required this.title,
    required this.company,
    required this.rating,
    required this.experience,
    required this.skills,
    required this.availability,
    required this.isVerified,
    required this.profileImage,
    this.isOnline = false,
  });
}

// Chat message model
class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final String? imageUrl;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.imageUrl,
    this.isRead = false,
  });
}

// MentorLink Provider
class MentorLinkProvider extends ChangeNotifier {
  List<Mentor> _mentors = [];
  List<Mentor> _filteredMentors = [];
  Map<String, List<ChatMessage>> _conversations = {};
  String _searchQuery = '';
  bool _isLoading = false;

  // Getters
  List<Mentor> get mentors => _filteredMentors.isEmpty && _searchQuery.isEmpty
      ? _mentors
      : _filteredMentors;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  // Initialize with sample data
  MentorLinkProvider() {
    _loadMentors();
  }

  void _loadMentors() {
    _mentors = [
      Mentor(
        id: '1',
        name: 'Dr. Emily Chen',
        title: 'Senior UX Researcher',
        company: 'Google',
        rating: 4.9,
        experience: '10+ years of experience in UX research and design. Passionate about mentoring the next generation of designers.',
        skills: ['UI/UX Design', 'User Research', 'Product Design'],
        availability: 'Available',
        isVerified: true,
        profileImage: 'assets/emily_chen.jpg',
        isOnline: true,
      ),
      Mentor(
        id: '2',
        name: 'James Wilson',
        title: 'Full Stack Developer',
        company: 'Amazon',
        rating: 4.8,
        experience: 'Full stack developer with expertise in React, Node.js, and AWS. Love helping students break into tech.',
        skills: ['Web Development', 'Mobile Development', 'Cloud Computing'],
        availability: 'Weekday',
        isVerified: true,
        profileImage: 'assets/james_wilson.jpg',
        isOnline: false,
      ),
      Mentor(
        id: '3',
        name: 'Sophia Lee',
        title: 'Product Manager',
        company: 'Microsoft',
        rating: 4.7,
        experience: 'Product management expert with focus on AI and machine learning products.',
        skills: ['Product Management', 'AI/ML', 'Strategy'],
        availability: 'Weekend',
        isVerified: true,
        profileImage: 'assets/sophia_lee.jpg',
        isOnline: true,
      ),
    ];
    _filteredMentors = List.from(_mentors);
    notifyListeners();
  }

  // Search functionality
  void searchMentors(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredMentors = List.from(_mentors);
    } else {
      _filteredMentors = _mentors.where((mentor) {
        return mentor.name.toLowerCase().contains(query.toLowerCase()) ||
            mentor.title.toLowerCase().contains(query.toLowerCase()) ||
            mentor.skills.any((skill) => skill.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    }
    notifyListeners();
  }

  // Filter by availability
  void filterByAvailability(String availability) {
    if (availability == 'All') {
      _filteredMentors = List.from(_mentors);
    } else {
      _filteredMentors = _mentors.where((mentor) =>
      mentor.availability == availability).toList();
    }
    notifyListeners();
  }

  // Get mentor by ID
  Mentor? getMentorById(String id) {
    try {
      return _mentors.firstWhere((mentor) => mentor.id == id);
    } catch (e) {
      return null;
    }
  }

  // Chat functionality
  List<ChatMessage> getConversation(String mentorId) {
    return _conversations[mentorId] ?? [];
  }

  void sendMessage(String mentorId, String message) {
    if (!_conversations.containsKey(mentorId)) {
      _conversations[mentorId] = [];
    }

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: message,
      isMe: true,
      timestamp: DateTime.now(),
    );

    _conversations[mentorId]!.add(newMessage);
    notifyListeners();

    // Simulate mentor response after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      _simulateMentorResponse(mentorId);
    });
  }

  void _simulateMentorResponse(String mentorId) {
    final responses = [
      "Thanks for reaching out! I'd be happy to help.",
      "That's a great question. Let me share my thoughts...",
      "I have experience with that. When would you like to schedule a call?",
      "Interesting project! I'd love to learn more about it.",
    ];

    final response = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: responses[DateTime.now().millisecond % responses.length],
      isMe: false,
      timestamp: DateTime.now(),
    );

    _conversations[mentorId]!.add(response);
    notifyListeners();
  }

  // Booking functionality
  Future<bool> bookSession(String mentorId, DateTime date, String time, String sessionType) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();

    // Return success (in real app, this would depend on API response)
    return true;
  }
}
