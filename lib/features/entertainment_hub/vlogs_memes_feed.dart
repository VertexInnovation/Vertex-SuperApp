import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VlogsMemesFeed extends StatefulWidget {
  const VlogsMemesFeed({super.key});

  @override
  State<VlogsMemesFeed> createState() => _VlogsMemesFeedState();
}

class _VlogsMemesFeedState extends State<VlogsMemesFeed> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  int _currentPlayingIndex = -1;

  final List<Map<String, dynamic>> _feedItems = [
    {
      'id': '1',
      'type': 'vlog',
      'title': 'A Day in My College Life',
      'creator': 'Sarah Johnson',
      'creatorAvatar': 'assets/images/sarah.jpg',
      'thumbnailUrl': 'assets/images/day_in_life.jpg',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      'likes': 342,
      'comments': 56,
      'shares': 23,
      'timeAgo': DateTime.now().subtract(const Duration(hours: 3)),
      'description': 'Follow me around campus to see how I manage my classes, study sessions and social life!',
      'isLiked': false,
      'isSaved': false,
      'tags': ['#collegelife', '#studywitme', '#dayroutine'],
    },
    {
      'id': '2',
      'type': 'meme',
      'title': 'When the professor says the exam will be easy',
      'creator': 'MemeEngineer',
      'creatorAvatar': 'assets/images/meme_engineer.jpg',
      'imageUrl': 'assets/images/exam_meme.jpg',
      'likes': 897,
      'comments': 42,
      'shares': 156,
      'timeAgo': DateTime.now().subtract(const Duration(hours: 5)),
      'description': 'We all know what happens next... 😂',
      'isLiked': false,
      'isSaved': false,
      'tags': ['#examseason', '#studentlife', '#thestruggleisreal'],
    },
    {
      'id': '3',
      'type': 'vlog',
      'title': 'Dorm Room Transformation',
      'creator': 'Alex Design',
      'creatorAvatar': 'assets/images/alex.jpg',
      'thumbnailUrl': 'assets/images/dorm_makeover.jpg',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      'likes': 215,
      'comments': 34,
      'shares': 18,
      'timeAgo': DateTime.now().subtract(const Duration(hours: 12)),
      'description': 'Watch how I transformed my boring dorm room into a stylish and functional space on a budget!',
      'isLiked': false,
      'isSaved': false,
      'tags': ['#dormlife', '#roomdecor', '#budgetmakeover'],
    },
    {
      'id': '4',
      'type': 'meme',
      'title': 'Group project expectations vs reality',
      'creator': 'CollegeHumor',
      'creatorAvatar': 'assets/images/college_humor.jpg',
      'imageUrl': 'assets/images/group_project_meme.jpg',
      'likes': 1245,
      'comments': 87,
      'shares': 320,
      'timeAgo': DateTime.now().subtract(const Duration(days: 1)),
      'description': 'Every. Single. Time.',
      'isLiked': false,
      'isSaved': false,
      'tags': ['#groupprojects', '#collegeproblems', '#whyisitalwaysme'],
    },
  ];

  final List<String> _trendingTags = [
    '#examseason',
    '#dormlife',
    '#campusfood',
    '#studygrind',
    '#collegefail',
    '#professorquotes',
    '#latenight',
    '#classstruggle',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _playVideo(int index) {
    final feedItem = _feedItems[index];

    if (feedItem['type'] == 'vlog' && _currentPlayingIndex != index) {
      _disposeCurrentVideo();

      _videoController = VideoPlayerController.network(feedItem['videoUrl']);
      _videoController!.initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _videoController!,
          autoPlay: true,
          looping: false,
          aspectRatio: 16 / 9,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                'Error loading video: $errorMessage',
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        );
        setState(() {
          _currentPlayingIndex = index;
        });
      });
    }
  }

  void _disposeCurrentVideo() {
    _chewieController?.dispose();
    _videoController?.dispose();
    _chewieController = null;
    _videoController = null;
    _currentPlayingIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(
              icon: Icon(Icons.video_library),
              text: 'Vlogs',
            ),
            Tab(
              icon: Icon(Icons.emoji_emotions),
              text: 'Memes',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _trendingTags.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: Chip(
                    label: Text(_trendingTags[index]),
                    backgroundColor: Colors.grey[200],
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildVlogsTab(),
                _buildMemesTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateContentBottomSheet();
        },
        child: const Icon(Icons.add),
        tooltip: 'Create content',
      ),
    );
  }

  Widget _buildVlogsTab() {
    final vlogs = _feedItems.where((item) => item['type'] == 'vlog').toList();

    if (vlogs.isEmpty) {
      return const Center(
        child: Text('No vlogs available yet'),
      );
    }

    return ListView.builder(
      itemCount: vlogs.length,
      itemBuilder: (context, index) {
        final vlog = vlogs[index];
        final originalIndex = _feedItems.indexOf(vlog);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(vlog['creatorAvatar']),
                ),
                title: Text(vlog['creator']),
                subtitle: Text(timeago.format(vlog['timeAgo'])),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ),
              InkWell(
                onTap: () => _playVideo(originalIndex),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: originalIndex == _currentPlayingIndex && _chewieController != null
                          ? Chewie(controller: _chewieController!)
                          : Image.asset(
                              vlog['thumbnailUrl'],
                              fit: BoxFit.cover,
                            ),
                    ),
                    if (originalIndex != _currentPlayingIndex)
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
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
                      vlog['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(vlog['description']),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      children: (vlog['tags'] as List<String>).map((tag) {
                        return Text(
                          tag,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: vlog['isLiked'] ? Icons.favorite : Icons.favorite_border,
                    label: '${vlog['likes']}',
                    color: vlog['isLiked'] ? Colors.red : null,
                    onTap: () {
                      setState(() {
                        vlog['isLiked'] = !vlog['isLiked'];
                        vlog['likes'] += vlog['isLiked'] ? 1 : -1;
                      });
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.comment_outlined,
                    label: '${vlog['comments']}',
                    onTap: () {
                      _showCommentsSheet(vlog);
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.share_outlined,
                    label: '${vlog['shares']}',
                    onTap: () {
                      // Implement share functionality
                    },
                  ),
                  _buildActionButton(
                    icon: vlog['isSaved'] ? Icons.bookmark : Icons.bookmark_border,
                    label: 'Save',
                    color: vlog['isSaved'] ? Theme.of(context).colorScheme.primary : null,
                    onTap: () {
                      setState(() {
                        vlog['isSaved'] = !vlog['isSaved'];
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMemesTab() {
    final memes = _feedItems.where((item) => item['type'] == 'meme').toList();

    if (memes.isEmpty) {
      return const Center(
        child: Text('No memes available yet'),
      );
    }

    return ListView.builder(
      itemCount: memes.length,
      itemBuilder: (context, index) {
        final meme = memes[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(meme['creatorAvatar']),
                ),
                title: Text(meme['creator']),
                subtitle: Text(timeago.format(meme['timeAgo'])),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ),
              Image.asset(
                meme['imageUrl'],
                fit: BoxFit.contain,
                width: double.infinity,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meme['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(meme['description']),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      children: (meme['tags'] as List<String>).map((tag) {
                        return Text(
                          tag,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: meme['isLiked'] ? Icons.favorite : Icons.favorite_border,
                    label: '${meme['likes']}',
                    color: meme['isLiked'] ? Colors.red : null,
                    onTap: () {
                      setState(() {
                        meme['isLiked'] = !meme['isLiked'];
                        meme['likes'] += meme['isLiked'] ? 1 : -1;
                      });
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.comment_outlined,
                    label: '${meme['comments']}',
                    onTap: () {
                      _showCommentsSheet(meme);
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.share_outlined,
                    label: '${meme['shares']}',
                    onTap: () {
                      // Implement share functionality
                    },
                  ),
                  _buildActionButton(
                    icon: meme['isSaved'] ? Icons.bookmark : Icons.bookmark_border,
                    label: 'Save',
                    color: meme['isSaved'] ? Theme.of(context).colorScheme.primary : null,
                    onTap: () {
                      setState(() {
                        meme['isSaved'] = !meme['isSaved'];
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }

  void _showCommentsSheet(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Comments for ${item['title']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Comments functionality coming soon!'),
            ],
          ),
        );
      },
    );
  }

  void _showCreateContentBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Create Content',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Content creation functionality coming soon!'),
            ],
          ),
        );
      },
    );
  }
}