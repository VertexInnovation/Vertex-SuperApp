import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';

class EventsStreaming extends StatefulWidget {
  const EventsStreaming({super.key});

  @override
  State<EventsStreaming> createState() => _EventsStreamingState();
}

class _EventsStreamingState extends State<EventsStreaming> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<Map<String, dynamic>> _liveEvents = [
    {
      'title': 'Game Night: Team Battle',
      'host': 'Gaming Club',
      'hostAvatar': 'assets/images/gaming_club.jpg',
      'category': 'Gaming',
      'viewers': 78,
      'thumbnailUrl': 'assets/images/game_night.jpg',
      'isLive': true,
      'startTime': DateTime.now().subtract(const Duration(minutes: 45)),
      'description': 'Join our weekly gaming tournament featuring Mario Kart and Super Smash Bros competitions. Prizes for top performers!',
    },
    {
      'title': 'Open Mic: Poetry Session',
      'host': 'Literary Society',
      'hostAvatar': 'assets/images/literary_society.jpg',
      'category': 'Performance',
      'viewers': 54,
      'thumbnailUrl': 'assets/images/open_mic.jpg',
      'isLive': true,
      'startTime': DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
      'description': 'Express yourself through poetry, spoken word, or storytelling. Everyone gets 5 minutes to share their creative work.',
    },
    {
      'title': 'Music Jam Session',
      'host': 'Music Club',
      'hostAvatar': 'assets/images/music_club.jpg',
      'category': 'Music',
      'viewers': 112,
      'thumbnailUrl': 'assets/images/music_jam.jpg',
      'isLive': true,
      'startTime': DateTime.now().subtract(const Duration(minutes: 20)),
      'description': 'Live jam session featuring student musicians collaborating on improvised music. Request your favorite songs in the chat!',
    },
  ];
  
  final List<Map<String, dynamic>> _upcomingEvents = [
    {
      'title': 'Virtual Talent Show',
      'host': 'Talent Club',
      'hostAvatar': 'assets/images/talent_club.jpg',
      'category': 'Performance',
      'viewers': 0,
      'thumbnailUrl': 'assets/images/talent_show.jpg',
      'isLive': false,
      'startTime': DateTime.now().add(const Duration(days: 1, hours: 4)),
      'description': 'Showcase your special talent - singing, dancing, magic tricks, or any unique skill you want to share with the campus!',
      'isReminded': false,
    },
    {
      'title': 'Coding Hackathon',
      'host': 'Tech Society',
      'hostAvatar': 'assets/images/tech_society.jpg',
      'category': 'Technology',
      'viewers': 0,
      'thumbnailUrl': 'assets/images/hackathon.jpg',
      'isLive': false,
      'startTime': DateTime.now().add(const Duration(days: 2)),
      'description': '48-hour coding challenge to build innovative solutions for campus problems. Teams of 2-4 students. Great prizes for winners!',
      'isReminded': false,
    },
    {
      'title': 'Comedy Night',
      'host': 'Drama Club',
      'hostAvatar': 'assets/images/drama_club.jpg',
      'category': 'Entertainment',
      'viewers': 0,
      'thumbnailUrl': 'assets/images/comedy_night.jpg',
      'isLive': false,
      'startTime': DateTime.now().add(const Duration(days: 3, hours: 6)),
      'description': 'Student standup comedy showcase with special guest performers. Guaranteed laughs and good vibes!',
      'isReminded': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Show search functionality
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(
              icon: Icon(Icons.live_tv),
              text: 'Live Now',
            ),
            Tab(
              icon: Icon(Icons.event),
              text: 'Upcoming',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLiveEventsTab(),
          _buildUpcomingEventsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCreateEventDialog();
        },
        icon: const Icon(Icons.add),
        label: const Text('Host Event'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildLiveEventsTab() {
    if (_liveEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.tv_off, // Changed from Icons.live_tv_off to Icons.tv_off
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'No live events right now',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Check back later or start your own event',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _liveEvents.length,
      itemBuilder: (context, index) {
        final event = _liveEvents[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              _navigateToEventDetails(event);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16/9,
                      child: Image.asset(
                        event['thumbnailUrl'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'LIVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.visibility,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${event['viewers']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: AssetImage(event['hostAvatar']),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event['host'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Started ${timeago.format(event['startTime'])}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _joinLiveEvent(event);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Join'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event['description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUpcomingEventsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _upcomingEvents.length,
      itemBuilder: (context, index) {
        final event = _upcomingEvents[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              _navigateToEventDetails(event);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16/9,
                      child: Image.asset(
                        event['thumbnailUrl'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.event,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              timeago.format(event['startTime'], allowFromNow: true),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: AssetImage(event['hostAvatar']),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event['host'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  event['category'],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              _toggleReminder(index);
                            },
                            icon: Icon(
                              event['isReminded'] ? Icons.notifications_active : Icons.notifications_none,
                              size: 16,
                            ),
                            label: Text(event['isReminded'] ? 'Reminded' : 'Remind me'),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event['description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_formatEventDate(event['startTime'])} · ${_formatEventTime(event['startTime'])}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToEventDetails(Map<String, dynamic> event) {
    // Navigate to event details screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              event['thumbnailUrl'],
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text('Host: ${event['host']}'),
            Text('Category: ${event['category']}'),
            const SizedBox(height: 8),
            Text(event['description']),
            const SizedBox(height: 8),
            event['isLive'] 
                ? Text('Started ${timeago.format(event['startTime'])}')
                : Text('Starts ${timeago.format(event['startTime'], allowFromNow: true)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (event['isLive']) {
                _joinLiveEvent(event);
              } else {
                // For upcoming events
                int index = _upcomingEvents.indexWhere((e) => e['title'] == event['title']);
                if (index != -1) {
                  _toggleReminder(index);
                }
              }
            },
            child: Text(event['isLive'] ? 'Join Now' : 'Set Reminder'),
          ),
        ],
      ),
    );
  }

  void _joinLiveEvent(Map<String, dynamic> event) {
    // Here you would implement the logic to join the live stream
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Joining ${event['title']}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleReminder(int index) {
    setState(() {
      _upcomingEvents[index]['isReminded'] = !_upcomingEvents[index]['isReminded'];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _upcomingEvents[index]['isReminded']
              ? 'Reminder set for ${_upcomingEvents[index]['title']}'
              : 'Reminder canceled for ${_upcomingEvents[index]['title']}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatEventDate(DateTime date) {
    final month = _getMonthName(date.month);
    return '$month ${date.day}';
  }

  String _formatEventTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  void _showCreateEventDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Host a New Event',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Event Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Gaming', child: Text('Gaming')),
                        DropdownMenuItem(value: 'Music', child: Text('Music')),
                        DropdownMenuItem(value: 'Performance', child: Text('Performance')),
                        DropdownMenuItem(value: 'Technology', child: Text('Technology')),
                        DropdownMenuItem(value: 'Entertainment', child: Text('Entertainment')),
                      ],
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        // Show date/time picker
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Set Date/Time'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle event creation
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Event created successfully! It will appear in the Upcoming Events tab.'),
                          ),
                        );
                      },
                      child: const Text('Create Event'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}