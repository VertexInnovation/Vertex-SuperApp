import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class VertexColors {
  static const Color honeyedAmber = Color(0xFFFFC0A3);
  static const Color deepSapphire = Color(0xFF000080);
  static const Color ceruleanBlue = Color(0xFF2962FF);
  static const Color oceanMist = Color(0xFF98D8D8);
  static const Color lightAmethyst = Color(0xFFE6C2E6);
}

class AIGeneratedContent extends StatefulWidget {
  const AIGeneratedContent({super.key});

  @override
  State<AIGeneratedContent> createState() => _AIGeneratedContentState();
}

class _AIGeneratedContentState extends State<AIGeneratedContent> {
  final List<Map<String, dynamic>> _aiTools = [
    {
      'title': 'Study Notes Generator',
      'description': 'Transform lecture materials into concise study notes',
      'icon': Icons.sticky_note_2_outlined,
      'color': VertexColors.honeyedAmber,
      'usageCredits': 80,
    },
    {
      'title': 'Essay Companion',
      'description': 'Get help structuring and refining your essays',
      'icon': Icons.edit_document,
      'color': VertexColors.ceruleanBlue,
      'usageCredits': 65,
    },
    {
      'title': 'Project Ideator',
      'description': 'Generate creative project ideas based on your interests',
      'icon': Icons.lightbulb_outline,
      'color': VertexColors.lightAmethyst,
      'usageCredits': 90,
    },
    {
      'title': 'Presentation Designer',
      'description': 'Create visually appealing slides with AI assistance',
      'icon': Icons.present_to_all,
      'color': VertexColors.oceanMist,
      'usageCredits': 40,
    },
  ];

  final List<Map<String, dynamic>> _communityCreations = [
    {
      'title': 'Mystery on Campus',
      'creator': 'Emily Chen',
      'type': 'Short Story',
      'likes': 324,
      'shares': 87,
      'imageUrl': 'assets/images/ai_story.jpg',
    },
    {
      'title': 'Future of Education',
      'creator': 'Prof. Williams',
      'type': 'Essay',
      'likes': 156,
      'shares': 42,
      'imageUrl': 'assets/images/ai_essay.jpg',
    },
    {
      'title': 'Digital Dreamscape',
      'creator': 'Alex Rivera',
      'type': 'AI Art Collection',
      'likes': 512,
      'shares': 203,
      'imageUrl': 'assets/images/ai_art.jpg',
    },
  ];

  final List<Map<String, dynamic>> _aiPromptsIdeas = [
    'A day in the life of a college student in 2050',
    'Design a solution for sustainable campus living',
    'Create a fantasy world inspired by your major',
    'Reimagine your favorite course as an adventure game',
    'Draft a speech about the future of your field',
  ];

  final TextEditingController _promptController = TextEditingController();
  bool _isGenerating = false;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: VertexColors.ceruleanBlue,
        onRefresh: () async {
          // Simulate refresh
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBanner(),
                _buildPromptField(),
                _buildAIToolsSection(),
                _buildCommunitySectionHeader(),
                _buildCommunityCreations(),
                _buildPromptIdeasSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            VertexColors.deepSapphire,
            VertexColors.ceruleanBlue,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'AI Creation Hub',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.flash_on, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '250 credits',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Create amazing content with AI assistance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPromptField() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What would you like to create?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: VertexColors.deepSapphire,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _promptController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter your prompt here...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: VertexColors.ceruleanBlue, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: !_isGenerating ? () {
                    if (_promptController.text.trim().isNotEmpty) {
                      setState(() {
                        _isGenerating = true;
                      });
                      // Simulate generation process
                      Future.delayed(const Duration(seconds: 3), () {
                        setState(() {
                          _isGenerating = false;
                        });
                        _showGeneratedContent(context);
                      });
                    }
                  } : null,
                  icon: _isGenerating 
                      ? const SizedBox(
                          width: 18, 
                          height: 18, 
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.auto_awesome),
                  label: Text(_isGenerating ? 'Generating...' : 'Generate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VertexColors.ceruleanBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAIToolsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Text(
            'AI Tools',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: VertexColors.deepSapphire,
            ),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _aiTools.length,
            itemBuilder: (context, index) {
              final tool = _aiTools[index];
              return Container(
                width: 160,
                margin: const EdgeInsets.all(4),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    onTap: () {
                      _showToolDetail(context, tool);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (tool['color'] as Color).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              tool['icon'] as IconData,
                              color: tool['color'] as Color,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            tool['title'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: VertexColors.deepSapphire,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tool['description'] as String,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Spacer(),
                          CircularPercentIndicator(
                            radius: 14,
                            lineWidth: 3,
                            percent: (tool['usageCredits'] as int) / 100,
                            center: Text(
                              '${tool['usageCredits']}%',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            progressColor: tool['color'] as Color,
                            backgroundColor: Colors.grey[200]!,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCommunitySectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Community Creations',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: VertexColors.deepSapphire,
            ),
          ),
          TextButton.icon(
            onPressed: () {
              // Navigate to all community creations
            },
            icon: const Icon(
              Icons.explore, 
              size: 16,
              color: VertexColors.ceruleanBlue,
            ),
            label: const Text(
              'Explore All',
              style: TextStyle(
                color: VertexColors.ceruleanBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityCreations() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _communityCreations.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final creation = _communityCreations[index];
        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Container(
                  height: 160,
                  width: double.infinity,
                  color: VertexColors.oceanMist.withOpacity(0.3),
                  child: Center(
                    child: Icon(
                      _getIconForType(creation['type'] as String),
                      size: 50,
                      color: VertexColors.deepSapphire.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: VertexColors.lightAmethyst.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            creation['type'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: VertexColors.deepSapphire,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.favorite, 
                          color: VertexColors.honeyedAmber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          creation['likes'].toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.share, 
                          color: VertexColors.ceruleanBlue,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          creation['shares'].toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      creation['title'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: VertexColors.deepSapphire,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Created by ${creation['creator']}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              // View content
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: VertexColors.ceruleanBlue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('View'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(