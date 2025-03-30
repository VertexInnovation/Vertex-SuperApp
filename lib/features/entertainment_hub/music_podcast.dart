import 'package:flutter/material.dart';

class MusicPodcast extends StatelessWidget {
  const MusicPodcast({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.headphones, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            "Music & Podcasts",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Discover and create music and podcasts by students!",
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement music/podcast creation
            },
            icon: const Icon(Icons.add),
            label: const Text("Create Content"),
          ),
        ],
      ),
    );
  }
}

