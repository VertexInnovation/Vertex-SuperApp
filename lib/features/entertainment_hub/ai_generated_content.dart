import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:like_button/like_button.dart';

class AIGeneratedContent extends StatefulWidget {
  const AIGeneratedContent({super.key});

  @override
  State<AIGeneratedContent> createState() => _AIGeneratedContentState();
}

class _AIGeneratedContentState extends State<AIGeneratedContent> {
  final TextEditingController _promptController = TextEditingController();
  final List<String> _suggestedTopics = [
    'Campus Life',
    'Exams',
    'Professors',
    'Homework',
    'Student Life',
    'Dorm',
    'Cafeteria',
    'Finals',
  ];
  
  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Meme generator card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.shade800,
                  Colors.deepPurple.shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "AI Meme Generator",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "Create hilarious college-themed memes with AI",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _promptController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter a topic or situation...",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        // TODO: Generate meme from prompt
                        if (_promptController.text.trim().isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Generating meme about: ${_promptController.text}')),
                          );
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Suggested topics
                const Text(
                  "Suggested Topics:",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _suggestedTopics.map((topic) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _promptController.text = topic;
                        });
                      },
                      child: Chip(
                        label: Text(topic),
                        backgroundColor: Colors.white.withOpacity(0.2),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // AI Challenge generator
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade800,
                  Colors.blue.shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "AI Challenge Generator",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "Create a personal or campus-wide challenge with AI",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Generate personal challenge
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Generating personal challenge')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          side: const BorderSide(color: Colors.white),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Personal Challenge"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Generate campus challenge
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Generating campus challenge')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                        ),
                        child: const Text("Campus Challenge"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        
          const SizedBox(height: 24),
        
          // Trending AI-generated content
          const Text(
            "Trending AI Content",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
        
          // Feed items
          _buildTrendingItem(
            context,
            username: "AI Assistant",
            contentType: "Meme",
            title: "When the professor says 'This won't be on the exam'",
            likes: 542,
            comments: 78,
            timeAgo: "1h ago",
          ),
          _buildTrendingItem(
            context,
            username: "AI Assistant",
            contentType: "Challenge",
            title: "The 'No Coffee for a Week' Challenge",
            likes: 327,
            comments: 45,
            timeAgo: "3h ago",
          ),
          _buildTrendingItem(
            context,
            username: "AI Assistant",
            contentType: "Meme",
            title: "Group project expectations vs reality",
            likes: 891,
            comments: 112,
            timeAgo: "6h ago",
          ),
          
          const SizedBox(height: 24),
          
          // AI content showcase
          const Text(
            "AI Content Showcase",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          MasonryGridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            itemCount: 6,
            itemBuilder: (context, index) {
              return _buildAIContentCard(
                context,
                type: index % 2 == 0 ? 'Meme' : 'Challenge',
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildTrendingItem(
    BuildContext context, {
    required String username,
    required String contentType,
    required String title,
    required int likes,
    required int comments,
    required String timeAgo,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(
            contentType == 'Meme' ? Icons.image : Icons.emoji_events,
            color: contentType == 'Meme' ? Colors.orange : Colors.green,
          ),
          backgroundColor: contentType == 'Meme'
              ? Colors.orange.withOpacity(0.2)
              : Colors.green.withOpacity(0.2),
        ),
        title: Text(title),
        subtitle: Row(
          children: [
            Text("$likes likes • $comments comments • $timeAgo"),
          ],
        ),
        onTap: () {
          // TODO: Show full content
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Viewing $contentType: $title')),
          );
        },
      ),
    );
  }
  
  Widget _buildAIContentCard(
    BuildContext context, {
    required String type,
  }) {
    final colors = type == 'Meme'
        ? [Colors.orange.shade200, Colors.orange.shade400]
        : [Colors.green.shade200, Colors.green.shade400];
    
    final icon = type == 'Meme' ? Icons.image : Icons.emoji_events;
    
    return Container(
      height: 180 + (type == 'Meme' ? 0 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            type == 'Meme'
                ? "Finals Week Meme"
                : "Study Sprint Challenge",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LikeButton(
                size: 20,
                likeCount: type == 'Meme' ? 412 : 253,
              ),
              const SizedBox(width: 16),
              const Icon(Icons.comment, size: 16, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                type == 'Meme' ? "63" : "32",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}