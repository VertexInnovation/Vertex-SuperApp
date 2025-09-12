import 'package:flutter/material.dart';

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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 14),
                    SizedBox(width: 2),
                    Text(
                      "AI",
                      style: TextStyle(color: Colors.white, fontSize: 12),
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
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              backgroundColor: _getColorForContentType(
                contentType,
              ).withOpacity(0.2),
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                IconButton(icon: const Icon(Icons.share), onPressed: () {}),
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
