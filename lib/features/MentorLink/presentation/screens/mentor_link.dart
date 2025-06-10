import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/Mentor_model.dart';
import 'booking_screen.dart';
import 'chat_screen.dart';

class MentorLink extends StatefulWidget {
  const MentorLink({super.key});

  @override
  State<MentorLink> createState() => _MentorLinkState();
}

class _MentorLinkState extends State<MentorLink> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      context.read<MentorLinkProvider>().searchMentors(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001232),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'MentorLink',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Connect with verified mentors',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),

              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 18.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFF263345),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Search mentors...",
                          hintStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          border: InputBorder.none,
                          filled: false,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xFF263345),
                    ),
                    child: IconButton(
                      onPressed: _showFilterDialog,
                      icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

// Filter chips (keep the existing filter chips section)
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ['All', 'Available', 'Weekday', 'Weekend'].map((filter) =>
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: _selectedFilter == filter,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                            context.read<MentorLinkProvider>().filterByAvailability(filter);
                          },
                          selectedColor: const Color(0xFFFFC500),
                          labelStyle: TextStyle(
                            color: _selectedFilter == filter
                                ? const Color(0xFF001232)
                                : Colors.white,
                          ),
                          backgroundColor: const Color(0xFF2A3B5A),
                        ),
                      ),
                  ).toList(),
                ),
              ),
              SizedBox(height: 20,),
              // Mentors List
              Expanded(
                child: Consumer<MentorLinkProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFFC500),
                        ),
                      );
                    }

                    if (provider.mentors.isEmpty) {
                      return const Center(
                        child: Text(
                          'No mentors found',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: provider.mentors.length,
                      itemBuilder: (context, index) {
                        final mentor = provider.mentors[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildMentorCard(mentor),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      //bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildMentorCard(Mentor mentor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2B4A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header - Fix overflow here
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xFFFFC500),
                    child: Text(
                      mentor.name.split(' ').map((e) => e[0]).join(),
                      style: const TextStyle(
                        color: Color(0xFF001232),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (mentor.isOnline)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF1A2B4A), width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded( // Wrap in Expanded to prevent overflow
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible( // Make name flexible
                          child: Text(
                            mentor.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (mentor.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            color: Color(0xFFFFC500),
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '${mentor.title} at ${mentor.company}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min, // Add this
                children: [
                  const Icon(Icons.star, color: Color(0xFFFFC500), size: 16),
                  const SizedBox(width: 4),
                  Text(
                    mentor.rating.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Experience Description
          Text(
            mentor.experience,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.4,
            ),
            maxLines: 3, // Limit lines to prevent overflow
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // Skills Tags - Fix overflow here
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: mentor.skills.map((skill) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A3B5A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    skill,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Availability and Action Buttons - Fix the main overflow issue
          Column( // Change from Row to Column for better layout
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: mentor.isOnline ? Colors.green : Colors.white54,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Flexible( // Make availability text flexible
                    child: Text(
                      'Available: ${mentor.availability}',
                      style: TextStyle(
                        color: mentor.isOnline ? Colors.green : Colors.white54,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _navigateToChat(mentor),
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size(50, 50),
                        foregroundColor: const Color(0xFFFFC500),
                        side: const BorderSide(color: Color(0xFFFFC500)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Message'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _navigateToBooking(mentor),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC500),
                        foregroundColor: const Color(0xFF001232),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Book Session'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A2B4A),
        title: const Text('Filter Mentors', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption('All'),
            _buildFilterOption('Available'),
            _buildFilterOption('Weekday'),
            _buildFilterOption('Weekend'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String option) {
    return RadioListTile<String>(
      title: Text(option, style: const TextStyle(color: Colors.white)),
      value: option,
      groupValue: _selectedFilter,
      activeColor: const Color(0xFFFFC500),
      onChanged: (value) {
        setState(() {
          _selectedFilter = value!;
        });
        context.read<MentorLinkProvider>().filterByAvailability(value!);
        Navigator.pop(context);
      },
    );
  }

  // Widget _buildBottomNavBar() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.06),
  //           blurRadius: 8,
  //         ),
  //       ],
  //     ),
  //     child: BottomNavigationBar(
  //       currentIndex: 3,
  //       type: BottomNavigationBarType.fixed,
  //       backgroundColor: const Color(0xFF001232),
  //       selectedItemColor: const Color(0xFFFFC500),
  //       unselectedItemColor: Colors.white,
  //       selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
  //       items: const [
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.home_outlined),
  //           activeIcon: Icon(Icons.home),
  //           label: 'Home',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.people_outline),
  //           activeIcon: Icon(Icons.people),
  //           label: 'QuickMatch',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.work_outline),
  //           activeIcon: Icon(Icons.work),
  //           label: 'GigBoard',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.school_outlined),
  //           activeIcon: Icon(Icons.school),
  //           label: 'MentorLink',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.person_outline),
  //           activeIcon: Icon(Icons.person),
  //           label: 'Profile',
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _navigateToChat(Mentor mentor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MentorChatScreen(mentor: mentor),
      ),
    );
  }

  void _navigateToBooking(Mentor mentor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MentorBookingScreen(mentor: mentor),
      ),
    );
  }
}

