import 'package:flutter/material.dart';
import 'features/entertainment_hub/entertainment_screen.dart';

void main() {
  runApp(const VertexApp());
}

class VertexApp extends StatelessWidget {
  const VertexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vertex SuperApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6200EE), // Primary purple color
          secondary: const Color(0xFF03DAC5), // Accent teal color
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeTab(),
    const ConnectivityTab(),
    const ProjectsTab(),
    const EntertainmentTab(),
    const CareerTab(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vertex', 
          style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Open notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // TODO: Open profile
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Connect',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_outlined),
            activeIcon: Icon(Icons.build),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.celebration_outlined),
            activeIcon: Icon(Icons.celebration),
            label: 'Fun',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            activeIcon: Icon(Icons.work),
            label: 'Career',
          ),
        ],
      ),
    );
  }
}

// Placeholder for Home Tab (Dashboard)
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Text(
            'Welcome back, Student!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // Activity Feed
          const Text(
            'Your Feed',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          
          // Sample feed items
          _buildFeedItem(
            context,
            title: 'New Project Opportunity',
            description: 'Join the AI Research Team looking for Flutter developers',
            icon: Icons.build,
            color: Colors.blue,
          ),
          _buildFeedItem(
            context,
            title: 'Upcoming Hackathon',
            description: 'Register for the annual coding competition next week',
            icon: Icons.code,
            color: Colors.orange,
          ),
          _buildFeedItem(
            context,
            title: 'New Connection Request',
            description: 'Alex from Computer Science wants to connect',
            icon: Icons.people,
            color: Colors.green,
          ),
          
          const SizedBox(height: 20),
          
          // Quick Access
          const Text(
            'Quick Access',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          
          // Grid of quick access buttons
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildQuickAccessItem(context, 'Find Study Partner', Icons.search, Colors.purple),
              _buildQuickAccessItem(context, 'New Project', Icons.add_box, Colors.blue),
              _buildQuickAccessItem(context, 'Browse Jobs', Icons.work, Colors.green),
              _buildQuickAccessItem(context, 'Events', Icons.event, Colors.orange),
              _buildQuickAccessItem(context, 'Campus Feed', Icons.school, Colors.red),
              _buildQuickAccessItem(context, 'My Profile', Icons.person, Colors.indigo),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeedItem(BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: Navigate to the relevant screen
        },
      ),
    );
  }
  
  Widget _buildQuickAccessItem(BuildContext context, String label, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        // TODO: Navigate to feature
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// Placeholder tabs for other sections
class ConnectivityTab extends StatelessWidget {
  const ConnectivityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Connectivity Hub Coming Soon'));
  }
}

class ProjectsTab extends StatelessWidget {
  const ProjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Projects Hub Coming Soon'));
  }
}

class EntertainmentTab extends StatefulWidget {
  const EntertainmentTab({super.key});

  @override
  State<EntertainmentTab> createState() => _EntertainmentTabState();
}

class _EntertainmentTabState extends State<EntertainmentTab> with SingleTickerProviderStateMixin {
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search for content, events, or creators...",
                      prefixIcon: const Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
                VlogMemeTab(),
                ChallengesTab(),
                EventsTab(),
                MusicPodcastTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContentCreationDialog(context);
        },
        child: const Icon(Icons.add),
        tooltip: "Create new content",
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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

// Individual tabs for each entertainment section
class TrendingTab extends StatelessWidget {
  const TrendingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // AI-generated content section
        const Text(
          "AI-Generated Just For You",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        // AI-generated meme cards
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildAIContentCard(
                context,
                title: "Campus Life Be Like...",
                imageUrl: "https://example.com/meme1.jpg",
                type: "Meme",
              ),
              _buildAIContentCard(
                context,
                title: "When Finals Week Hits",
                imageUrl: "https://example.com/meme2.jpg",
                type: "Meme",
              ),
              _buildAIContentCard(
                context,
                title: "Professor: 'This will be on the test'",
                imageUrl: "https://example.com/meme3.jpg",
                type: "Meme",
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Trending content
        const Text(
          "Trending on Campus",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        // Feed items
        _buildTrendingItem(
          context,
          username: "Alex Chen",
          userAvatar: "https://example.com/alex.jpg",
          contentType: "Vlog",
          title: "A Day in My Engineering Life",
          likes: 342,
          comments: 56,
          timeAgo: "2h ago",
          thumbnailUrl: "https://example.com/vlog1.jpg",
        ),
        _buildTrendingItem(
          context,
          username: "Maya Johnson",
          userAvatar: "https://example.com/maya.jpg",
          contentType: "Challenge",
          title: "5 Days No-Coffee Challenge Results",
          likes: 289,
          comments: 77,
          timeAgo: "4h ago",
          thumbnailUrl: "https://example.com/challenge1.jpg",
        ),
        _buildTrendingItem(
          context,
          username: "CS Club",
          userAvatar: "https://example.com/csclub.jpg",
          contentType: "Event",
          title: "Virtual Game Night this Friday!",
          likes: 154,
          comments: 32,
          timeAgo: "8h ago",
          thumbnailUrl: "https://example.com/event1.jpg",
        ),
      ],
    );
  }
  
  Widget _buildAIContentCard(
    BuildContext context, {
    required String title,
    required String imageUrl,
    required String type,
  }) {
    return Card(
      margin: const EdgeInsets.only(right: 16, bottom: 4),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width: 180,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: Colors.grey[300], // Placeholder for image
              // Use Image.network(imageUrl) for actual image
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      "AI",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTrendingItem(
    BuildContext context, {
    required String username,
    required String userAvatar,
    required String contentType,
    required String title,
    required int likes,
    required int comments,
    required String timeAgo,
    required String thumbnailUrl,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info and post header
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              // Use Image.network(userAvatar) for actual avatar
            ),
            title: Text(
              username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(timeAgo),
            trailing: Chip(
              label: Text(contentType),
              backgroundColor: _getColorForContentType(contentType).withOpacity(0.2),
              labelStyle: TextStyle(
                color: _getColorForContentType(contentType),
                fontSize: 12,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
          
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          
          // Thumbnail
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              // Use Image.network(thumbnailUrl) for actual thumbnail
            ),
          ),
          
          // Action buttons
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
                Text('$likes'),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {},
                ),
                Text('$comments'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getColorForContentType(String type) {
    switch (type) {
      case 'Vlog':
        return Colors.blue;
      case 'Meme':
        return Colors.orange;
      case 'Challenge':
        return Colors.green;
      case 'Event':
        return Colors.purple;
      case 'Podcast':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

// Placeholder for other tabs
class VlogMemeTab extends StatelessWidget {
  const VlogMemeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Vlogs & Memes coming soon'));
  }
}

class ChallengesTab extends StatelessWidget {
  const ChallengesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Challenges coming soon'));
  }
}

class EventsTab extends StatelessWidget {
  const EventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Events coming soon'));
  }
}

class MusicPodcastTab extends StatelessWidget {
  const MusicPodcastTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Music & Podcasts coming soon'));
  }
}

class CareerTab extends StatelessWidget {
  const CareerTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Career Hub Coming Soon'));
  }
}