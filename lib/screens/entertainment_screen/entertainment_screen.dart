import 'package:flutter/material.dart';
import 'package:vertex_app/features/entertainment_hub/campus_challenges.dart';
import 'package:vertex_app/features/entertainment_hub/events_streaming.dart';
import 'package:vertex_app/features/entertainment_hub/music_podcast.dart';
import 'package:vertex_app/features/entertainment_hub/vlogs_memes_feed.dart';
import 'package:vertex_app/main.dart';
import 'package:vertex_app/screens/entertainment_screen/trending_tab.dart';

class EntertainmentTab extends StatefulWidget {
  const EntertainmentTab({super.key});

  @override
  State<EntertainmentTab> createState() => _EntertainmentTabState();
}

class _EntertainmentTabState extends State<EntertainmentTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
          Container(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Entertainment Hub",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Discover fun and relaxation in your campus community",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),

                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Search for content, events, or creators...",
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),

          // Tab Bar for different entertainment sections
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(text: "Trending", icon: Icon(Icons.trending_up)),
              Tab(text: "Vlogs & Memes", icon: Icon(Icons.video_library)),
              Tab(text: "Challenges", icon: Icon(Icons.emoji_events)),
              Tab(text: "Events", icon: Icon(Icons.event)),
              Tab(text: "Music & Podcasts", icon: Icon(Icons.headphones)),
            ],
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                TrendingTab(),
                VlogsMemesFeed(),
                CampusChallenges(),
                EventsStreaming(),
                MusicPodcast(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContentCreationDialog(context);
        },
        tooltip: "Create new content",
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showContentCreationDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Create New Content",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildCreationOption(
                context,
                icon: Icons.video_call,
                title: "Post a Vlog",
                description: "Share your day or experiences",
                color: Colors.blue,
              ),
              _buildCreationOption(
                context,
                icon: Icons.image,
                title: "Create a Meme",
                description: "Make others laugh with your creativity",
                color: Colors.orange,
              ),
              _buildCreationOption(
                context,
                icon: Icons.campaign,
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
        // TODO: Navigate to the corresponding content creation screen
      },
    );
  }
}
