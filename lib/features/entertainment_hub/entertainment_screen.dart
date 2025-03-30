import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:vertex_app/features/entertainment_hub/vlogs_memes_feed.dart';
import 'package:vertex_app/features/entertainment_hub/campus_challenges.dart';
import 'package:vertex_app/features/entertainment_hub/ai_generated_content.dart';
import 'package:vertex_app/features/entertainment_hub/events_streaming.dart';
import 'package:vertex_app/features/entertainment_hub/music_podcast.dart';

class EntertainmentTab extends StatefulWidget {
  const EntertainmentTab({super.key});

  @override
  State<EntertainmentTab> createState() => _EntertainmentTabState();
}

class _EntertainmentTabState extends State<EntertainmentTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _trending = [
    'Campus Battle Royale: Science vs Arts',
    'Professor Smith\'s Epic Fail Compilation',
    'Midnight Library Sessions',
    'Dorm Room Cooking Disasters',
    'When Finals Week Hits Different'
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header with welcome message and trending topics
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Entertainment Hub',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {
                        // TODO: Show entertainment notifications
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Trending carousel
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.trending_up, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Trending Now',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 30,
                        child: CarouselSlider(
                          options: CarouselOptions(
                            viewportFraction: 1.0,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 5),
                            autoPlayAnimationDuration: const Duration(milliseconds: 800),
                            pauseAutoPlayOnTouch: true,
                            scrollDirection: Axis.vertical,
                          ),
                          items: _trending.map((item) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Text(
                                  item,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Navigation tabs
          Container(
            margin: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3,
              tabs: const [
                Tab(
                  icon: Icon(Icons.stream),
                  text: "Feed",
                ),
                Tab(
                  icon: Icon(Icons.videogame_asset),
                  text: "Challenges",
                ),
                Tab(
                  icon: Icon(Icons.auto_awesome),
                  text: "AI Content",
                ),
                Tab(
                  icon: Icon(Icons.event),
                  text: "Events",
                ),
                Tab(
                  icon: Icon(Icons.headphones),
                  text: "Music & Podcasts",
                ),
              ],
            ),
          ),
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                VlogsMemesFeed(),
                CampusChallenges(),
                AIGeneratedContent(),
                EventsStreaming(),
                MusicPodcast(),
              ],
            ),
          ),
        ],
      ),
      
      // Create content FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateContentSheet(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  
  void _showCreateContentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create Something Awesome",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              _buildCreationOption(
                context,
                icon: Icons.video_camera_back,
                title: "Record a Vlog",
                description: "Share your day or an interesting story",
                color: Colors.blue,
              ),
              _buildCreationOption(
                context,
                icon: Icons.image,
                title: "Create a Meme",
                description: "Make everyone laugh with your creativity",
                color: Colors.orange,
              ),
              _buildCreationOption(
                context,
                icon: Icons.emoji_events,
                title: "Start a Challenge",
                description: "Create a fun activity for your campus",
                color: Colors.green,
              ),
              _buildCreationOption(
                context,
                icon: Icons.event,
                title: "Host an Event",
                description: "Organize a virtual meetup or talent show",
                color: Colors.purple,
              ),
              _buildCreationOption(
                context,
                icon: Icons.mic,
                title: "Record Podcast/Music",
                description: "Share your voice or musical talent",
                color: Colors.red,
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildCreationOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(description),
      onTap: () {
        Navigator.pop(context);
        // TODO: Navigate to the specific content creation screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Create $title coming soon!')),
        );
      },
    );
  }
}