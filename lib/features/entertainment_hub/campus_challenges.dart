import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CampusChallenges extends StatefulWidget {
  const CampusChallenges({super.key});

  @override
  State<CampusChallenges> createState() => _CampusChallengesState();
}

class _CampusChallengesState extends State<CampusChallenges>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCategoryIndex = 0;
  final bool _isJoined = false;
  final bool _showOnlyActive = false;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.category},
    {'name': 'Academic', 'icon': Icons.school},
    {'name': 'Fitness', 'icon': Icons.fitness_center},
    {'name': 'Creative', 'icon': Icons.palette},
    {'name': 'Social', 'icon': Icons.people},
    {'name': 'Tech', 'icon': Icons.computer},
  ];

  final List<Map<String, dynamic>> _challenges = [
    {
      'title': '30-Day Coding Challenge',
      'description': 'Code for at least 30 minutes every day for 30 days',
      'participants': 234,
      'daysLeft': 15,
      'category': 'Tech',
      'difficulty': 'Medium',
      'rewards': ['Badge: Code Warrior', 'Certificate', '50 Vertex Points'],
      'coverImage': 'assets/images/coding_challenge.jpg',
      'progress': 0.5,
      'isActive': true,
      'creator': 'CS Department',
      'creatorAvatar': 'assets/images/cs_department.jpg',
    },
    {
      'title': 'Campus Photo Contest',
      'description': 'Capture the most creative shot of your campus life',
      'participants': 178,
      'daysLeft': 3,
      'category': 'Creative',
      'difficulty': 'Easy',
      'rewards': [
        'Featured in Campus Magazine',
        '100 Vertex Points',
        'Photography Workshop Access'
      ],
      'coverImage': 'assets/images/photo_contest.jpg',
      'progress': 0.8,
      'isActive': true,
      'creator': 'Photography Club',
      'creatorAvatar': 'assets/images/photography_club.jpg',
    },
    {
      'title': 'Research Paper Marathon',
      'description': 'Read one research paper a day for 15 days',
      'participants': 89,
      'daysLeft': 7,
      'category': 'Academic',
      'difficulty': 'Hard',
      'rewards': [
        'Badge: Research Pro',
        '150 Vertex Points',
        'Access to Premium Research Database'
      ],
      'coverImage': 'assets/images/research_marathon.jpg',
      'progress': 0.6,
      'isActive': true,
      'creator': 'Academic Excellence Center',
      'creatorAvatar': 'assets/images/academic_center.jpg',
    },
    {
      'title': 'Morning Workout Week',
      'description': 'Complete a 20-minute workout every morning for 7 days',
      'participants': 312,
      'daysLeft': 0,
      'category': 'Fitness',
      'difficulty': 'Medium',
      'rewards': [
        'Badge: Early Bird Fitness',
        '75 Vertex Points',
        'Gym Discount'
      ],
      'coverImage': 'assets/images/morning_workout.jpg',
      'progress': 1.0,
      'isActive': false,
      'creator': 'Campus Fitness',
      'creatorAvatar': 'assets/images/campus_fitness.jpg',
    },
    {
      'title': 'Random Acts of Kindness',
      'description': 'Complete one random act of kindness daily for 5 days',
      'participants': 267,
      'daysLeft': 2,
      'category': 'Social',
      'difficulty': 'Easy',
      'rewards': [
        'Badge: Campus Angel',
        '50 Vertex Points',
        'Community Service Credit'
      ],
      'coverImage': 'assets/images/kindness_acts.jpg',
      'progress': 0.7,
      'isActive': true,
      'creator': 'Student Wellness Center',
      'creatorAvatar': 'assets/images/wellness_center.jpg',
    },
  ];

  final List<Map<String, dynamic>> _leaderboard = [
    {
      'rank': 1,
      'name': 'Alex Johnson',
      'avatar': 'assets/images/alex.jpg',
      'points': 3750,
      'badges': 8,
      'completedChallenges': 12,
    },
    {
      'rank': 2,
      'name': 'Samantha Lee',
      'avatar': 'assets/images/samantha.jpg',
      'points': 3240,
      'badges': 7,
      'completedChallenges': 10,
    },
    {
      'rank': 3,
      'name': 'Miguel Rodriguez',
      'avatar': 'assets/images/miguel.jpg',
      'points': 2980,
      'badges': 6,
      'completedChallenges': 9,
    },
    {
      'rank': 4,
      'name': 'Emma Wilson',
      'avatar': 'assets/images/emma.jpg',
      'points': 2745,
      'badges': 5,
      'completedChallenges': 8,
    },
    {
      'rank': 5,
      'name': 'James Liu',
      'avatar': 'assets/images/james.jpg',
      'points': 2510,
      'badges': 5,
      'completedChallenges': 7,
    },
    {
      'rank': 6,
      'name': 'Olivia Martinez',
      'avatar': 'assets/images/olivia.jpg',
      'points': 2350,
      'badges': 4,
      'completedChallenges': 7,
    },
    {
      'rank': 7,
      'name': 'David Kim',
      'avatar': 'assets/images/david.jpg',
      'points': 2180,
      'badges': 4,
      'completedChallenges': 6,
    },
    {
      'rank': 8,
      'name': 'Sophia Wang',
      'avatar': 'assets/images/sophia.jpg',
      'points': 1980,
      'badges': 4,
      'completedChallenges': 6,
    },
    {
      'rank': 9,
      'name': 'Ethan Brown',
      'avatar': 'assets/images/ethan.jpg',
      'points': 1820,
      'badges': 3,
      'completedChallenges': 5,
    },
    {
      'rank': 10,
      'name': 'Isabella Garcia',
      'avatar': 'assets/images/isabella.jpg',
      'points': 1650,
      'badges': 3,
      'completedChallenges': 5,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor: Colors.grey,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(text: "Explore", icon: Icon(Icons.explore)),
                    Tab(text: "My Challenges", icon: Icon(Icons.person)),
                    Tab(text: "Leaderboard", icon: Icon(Icons.leaderboard)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildExploreTab(),
                _buildMyChallengesTab(),
                _buildLeaderboardTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index != 2
          ? FloatingActionButton.extended(
              onPressed: () {
                _showCreateChallengeDialog(context);
              },
              icon: const Icon(Icons.add),
              label: const Text("Create Challenge"),
            )
          : null,
    );
  }

  Widget _buildExploreTab() {
    return Column(
      children: [
        // Categories
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedCategoryIndex == index
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        category['icon'],
                        color: _selectedCategoryIndex == index
                            ? Colors.white
                            : Colors.grey[600],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category['name'],
                        style: TextStyle(
                          color: _selectedCategoryIndex == index
                              ? Colors.white
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Challenges
        Expanded(
          child: ListView.builder(
            itemCount: _challenges.length,
            itemBuilder: (context, index) {
              final challenge = _challenges[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(challenge['coverImage']),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            challenge['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(challenge['description']),
                          const SizedBox(height: 8),
                          LinearPercentIndicator(
                            lineHeight: 14.0,
                            percent: challenge['progress'],
                            backgroundColor: Colors.grey[200],
                            progressColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
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

  Widget _buildMyChallengesTab() {
    return const Center(
      child: Text("My Challenges"),
    );
  }

  Widget _buildLeaderboardTab() {
    return ListView.builder(
      itemCount: _leaderboard.length,
      itemBuilder: (context, index) {
        final user = _leaderboard[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(user['avatar']),
          ),
          title: Text(user['name']),
          subtitle: Text("Points: ${user['points']}"),
          trailing: Text("Rank: ${user['rank']}"),
        );
      },
    );
  }

  void _showCreateChallengeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Create Challenge"),
          content: const Text("Challenge creation form goes here."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement challenge creation logic
                Navigator.of(context).pop();
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }
}
