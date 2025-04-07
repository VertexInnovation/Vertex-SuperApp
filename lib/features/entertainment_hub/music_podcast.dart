import 'package:flutter/material.dart';

class VertexColors {
  static const Color honeyedAmber = Color(0xFFFFC0A3);
  static const Color deepSapphire = Color(0xFF000080);
  static const Color ceruleanBlue = Color(0xFF2962FF);
  static const Color oceanMist = Color(0xFF98D8D8);
  static const Color lightAmethyst = Color(0xFFE6C2E6);
}

class MusicPodcast extends StatefulWidget {
  const MusicPodcast({super.key});

  @override
  State<MusicPodcast> createState() => _MusicPodcastState();
}

class _MusicPodcastState extends State<MusicPodcast> {
  final List<Map<String, dynamic>> _featuredContent = [
    {
      'title': 'Morning Study Mix',
      'creator': 'DJ StudyBuddy',
      'type': 'Playlist',
      'imageUrl': 'assets/images/music_study.jpg',
      'duration': '45 min',
    },
    {
      'title': 'Campus Life Podcast',
      'creator': 'Sarah & Mike',
      'type': 'Podcast',
      'imageUrl': 'assets/images/podcast_campus.jpg',
      'duration': '32 min',
    },
    {
      'title': 'Exam Preparation Sounds',
      'creator': 'Focus Audio',
      'type': 'Ambient',
      'imageUrl': 'assets/images/ambient_focus.jpg',
      'duration': '60 min',
    },
  ];

  final List<Map<String, dynamic>> _topPodcasts = [
    {
      'title': 'Student Success Stories',
      'creator': 'Academic Excellence Club',
      'episodes': 24,
      'imageUrl': 'assets/images/podcast_success.jpg',
    },
    {
      'title': 'Science Simplified',
      'creator': 'Professor Johnson',
      'episodes': 18,
      'imageUrl': 'assets/images/podcast_science.jpg',
    },
    {
      'title': 'Dorm Room Discussions',
      'creator': 'Campus Housing Network',
      'episodes': 32,
      'imageUrl': 'assets/images/podcast_dorm.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _featuredContent.isEmpty 
        ? _buildEmptyState() 
        : _buildContentList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateContentModal();
        },
        backgroundColor: VertexColors.ceruleanBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: VertexColors.lightAmethyst,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.headphones, 
              size: 64, 
              color: VertexColors.deepSapphire
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Music & Podcasts",
            style: TextStyle(
              fontSize: 24, 
              fontWeight: FontWeight.bold,
              color: VertexColors.deepSapphire,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "Discover and create music and podcasts by students!",
              style: TextStyle(
                color: Colors.grey[600], 
                fontSize: 16
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              _showCreateContentModal();
            },
            icon: const Icon(Icons.add),
            label: const Text("Create Content"),
            style: ElevatedButton.styleFrom(
              backgroundColor: VertexColors.ceruleanBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentList() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeaturedSection(),
          const SizedBox(height: 24),
          _buildTopPodcastsSection(),
          const SizedBox(height: 24),
          _buildMusicCategoriesSection(),
          const SizedBox(height: 24),
          _buildNewReleasesSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: VertexColors.deepSapphire,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'See All',
              style: TextStyle(
                color: VertexColors.ceruleanBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Featured For You'),
        SizedBox(
          height: 220,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: _featuredContent.length,
            itemBuilder: (context, index) {
              final item = _featuredContent[index];
              return Container(
                margin: const EdgeInsets.all(4),
                width: 160,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 120,
                              color: VertexColors.oceanMist.withOpacity(0.3),
                              child: Center(
                                child: Icon(
                                  item['type'] == 'Podcast' ? Icons.mic : Icons.music_note,
                                  size: 30,
                                  color: VertexColors.deepSapphire,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 8,
                              bottom: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: VertexColors.deepSapphire,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item['duration'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['creator'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: item['type'] == 'Podcast' 
                                    ? VertexColors.honeyedAmber.withOpacity(0.3) 
                                    : VertexColors.lightAmethyst.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item['type'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: item['type'] == 'Podcast' 
                                      ? VertexColors.deepSapphire
                                      : VertexColors.deepSapphire,
                                ),
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
          ),
        ),
      ],
    );
  }

  Widget _buildTopPodcastsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Top Podcasts'),
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _topPodcasts.length,
          itemBuilder: (context, index) {
            final item = _topPodcasts[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: VertexColors.honeyedAmber.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.mic, color: VertexColors.deepSapphire),
                  ),
                ),
                title: Text(
                  item['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${item['creator']} • ${item['episodes']} episodes',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.play_circle_filled_rounded,
                    color: VertexColors.ceruleanBlue,
                    size: 36,
                  ),
                  onPressed: () {
                    // Play podcast
                  },
                ),
                onTap: () {
                  // Open podcast details
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMusicCategoriesSection() {
    final categories = [
      {'name': 'Study', 'icon': Icons.book},
      {'name': 'Workout', 'icon': Icons.fitness_center},
      {'name': 'Relaxation', 'icon': Icons.spa},
      {'name': 'Party', 'icon': Icons.celebration},
      {'name': 'Focus', 'icon': Icons.psychology},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Music Categories'),
        SizedBox(
          height: 100,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Container(
                margin: const EdgeInsets.only(right: 16),
                width: 80,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            VertexColors.oceanMist,
                            VertexColors.lightAmethyst,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        category['icon'] as IconData,
                        color: VertexColors.deepSapphire,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['name'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNewReleasesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('New Releases'),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [
                VertexColors.honeyedAmber,
                VertexColors.oceanMist,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.new_releases,
                    color: VertexColors.deepSapphire,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Featured Release',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: VertexColors.deepSapphire,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.album,
                        color: VertexColors.ceruleanBlue,
                        size: 50,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Campus Beats Vol. 3',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: VertexColors.deepSapphire,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Vertex Music Society',
                          style: TextStyle(
                            color: VertexColors.deepSapphire.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '12 tracks • Released today',
                          style: TextStyle(
                            color: VertexColors.deepSapphire,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: VertexColors.deepSapphire,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            minimumSize: const Size(120, 36),
                          ),
                          child: const Text('Listen Now'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCreateContentModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Audio Content',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: VertexColors.deepSapphire,
                ),
              ),
              const SizedBox(height: 16),
              _buildContentOption(
                context,
                icon: Icons.music_note,
                title: 'Upload Music',
                description: 'Share your musical talent with the campus',
                color: VertexColors.ceruleanBlue,
              ),
              _buildContentOption(
                context,
                icon: Icons.mic,
                title: 'Start Podcast',
                description: 'Create your own podcast series',
                color: VertexColors.honeyedAmber,
              ),
              _buildContentOption(
                context,
                icon: Icons.playlist_add,
                title: 'Create Playlist',
                description: 'Curate songs and share with friends',
                color: VertexColors.oceanMist,
              ),
              _buildContentOption(
                context,
                icon: Icons.record_voice_over,
                title: 'Record Audio Story',
                description: 'Share experiences through audio',
                color: VertexColors.lightAmethyst,
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContentOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: VertexColors.deepSapphire,
        ),
      ),
      subtitle: Text(description),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title coming soon!'),
            backgroundColor: VertexColors.deepSapphire,
          ),
        );
      },
    );
  }
}

