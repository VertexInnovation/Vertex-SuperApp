import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/Mentor_model.dart';
import 'chat_screen.dart';

class MentorBookingScreen extends StatefulWidget {
  final Mentor mentor;

  const MentorBookingScreen({super.key, required this.mentor});

  @override
  State<MentorBookingScreen> createState() => _MentorBookingScreenState();
}

class _MentorBookingScreenState extends State<MentorBookingScreen> {
  String selectedDate = 'Today';
  String selectedTime = '9:00';
  String sessionType = '1:1 Video Call';

  final List<String> availableDates = ['Today', 'Tomorrow', 'Wed, May', 'Thu, May'];
  final List<String> availableTimes = ['9:00', '11:00', '2:00', '4:00'];
  final List<String> sessionTypes = ['1:1 Video Call', '1:1 Audio Call', 'Group Session'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001232),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001232),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mentor Profile',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () => _shareMentorProfile(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFFFFC500),
                        child: Text(
                          widget.mentor.name.split(' ').map((e) => e[0]).join(),
                          style: const TextStyle(
                            color: Color(0xFF001232),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (widget.mentor.isOnline)
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF001232), width: 3),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.mentor.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (widget.mentor.isVerified)
                        const Icon(
                          Icons.verified,
                          color: Color(0xFFFFC500),
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.mentor.title} at ${widget.mentor.company}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFFC500), size: 20),
                      const SizedBox(width: 4),
                      Text(
                        widget.mentor.rating.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time,
                        color: widget.mentor.isOnline ? Colors.green : Colors.white54,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Available: ${widget.mentor.availability}',
                        style: TextStyle(
                          color: widget.mentor.isOnline ? Colors.green : Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MentorChatScreen(mentor: widget.mentor),
                        ),
                      ),
                      icon: const Icon(Icons.message),
                      label: const Text('Message'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFFC500),
                        side: const BorderSide(color: Color(0xFFFFC500)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // About Section
            const Text(
              'About',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.mentor.experience,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Expertise Section
            const Text(
              'Expertise',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.mentor.skills.map((skill) =>
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A3B5A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      skill,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ).toList(),
            ),
            const SizedBox(height: 32),

            // Book a Session Section
            const Text(
              'Book a Session',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Date Selection
            const Text(
              'Select Date',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: availableDates.length,
                itemBuilder: (context, index) {
                  final date = availableDates[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildSelectionButton(
                      date,
                      selectedDate == date,
                          () => setState(() => selectedDate = date),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Time Selection
            const Text(
              'Select Time',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: availableTimes.length,
                itemBuilder: (context, index) {
                  final time = availableTimes[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildSelectionButton(
                      time,
                      selectedTime == time,
                          () => setState(() => selectedTime = time),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Session Type
            const Text(
              'Session Type',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: sessionType,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF2A3B5A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              dropdownColor: const Color(0xFF2A3B5A),
              style: const TextStyle(color: Colors.white),
              items: sessionTypes.map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  sessionType = value!;
                });
              },
            ),
            const SizedBox(height: 32),

            // Book Button
            Consumer<MentorLinkProvider>(
              builder: (context, provider, child) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : _bookSession,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC500),
                      foregroundColor: const Color(0xFF001232),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: provider.isLoading
                        ? const CircularProgressIndicator(
                      color: Color(0xFF001232),
                    )
                        : const Text(
                      'Book Session',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFC500) : const Color(0xFF2A3B5A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? const Color(0xFF001232) : Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _bookSession() async {
    final provider = context.read<MentorLinkProvider>();
    final success = await provider.bookSession(
      widget.mentor.id,
      DateTime.now(), // In real app, parse selectedDate
      selectedTime,
      sessionType,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Session booked successfully!'),
          backgroundColor: Color(0xFFFFC500),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to book session. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _shareMentorProfile() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mentor profile shared!'),
        backgroundColor: Color(0xFFFFC500),
      ),
    );
  }
}
