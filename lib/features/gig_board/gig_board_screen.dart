import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;


// Models
class Gig {
  final String id;
  final String title;
  final String description;
  final int budget;
  final String deadline;
  final List<String> requiredSkills;
  final String postedBy;
  final String posterUniversity;
  final String status;
  final DateTime createdAt;
  final String? posterImage;
  final bool isBookmarked;

  Gig({
    required this.id,
    required this.title,
    required this.description,
    required this.budget,
    required this.deadline,
    required this.requiredSkills,
    required this.postedBy,
    required this.posterUniversity,
    required this.status,
    required this.createdAt,
    this.posterImage,
    this.isBookmarked = false,
  });

  Gig copyWith({
    String? id,
    String? title,
    String? description,
    int? budget,
    String? deadline,
    List<String>? requiredSkills,
    String? postedBy,
    String? posterUniversity,
    String? status,
    DateTime? createdAt,
    String? posterImage,
    bool? isBookmarked,
  }) {
    return Gig(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      budget: budget ?? this.budget,
      deadline: deadline ?? this.deadline,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      postedBy: postedBy ?? this.postedBy,
      posterUniversity: posterUniversity ?? this.posterUniversity,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      posterImage: posterImage ?? this.posterImage,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

// Provider for GigBoard state management
class GigBoardProvider extends ChangeNotifier {
  final List<Gig> _gigs = [
    Gig(
      id: '1',
      title: 'UI Design for Student App',
      description:
          'Looking for a UI designer to create mockups for a student productivity app. Need someone with experience in modern design principles and mobile-first approach.',
      budget: 200,
      deadline: '2 weeks',
      requiredSkills: ['UI/UX Design', 'Mobile Development'],
      postedBy: 'Alex Chen',
      posterUniversity: 'MIT',
      status: 'Open',
      createdAt: DateTime.now().subtract(Duration(hours: 2)),
    ),
    Gig(
      id: '2',
      title: 'Content Writer for Blog',
      description:
          'Need a content writer for our tech blog. Topics include AI, machine learning, and tech trends.',
      budget: 150,
      deadline: '1 week',
      requiredSkills: ['Content Writing', 'SEO'],
      postedBy: 'Sophia Lee',
      posterUniversity: 'MIT',
      status: 'Open',
      createdAt: DateTime.now().subtract(Duration(hours: 5)),
    ),
    Gig(
      id: '3',
      title: 'Social Media Campaign',
      description:
          'Looking for someone to create and manage a social media campaign for our student event.',
      budget: 300,
      deadline: '3 weeks',
      requiredSkills: ['Marketing', 'Social Media'],
      postedBy: 'Mike Johnson',
      posterUniversity: 'Stanford',
      status: 'Open',
      createdAt: DateTime.now().subtract(Duration(days: 1)),
    ),
  ];

  String _searchQuery = '';
  List<String> _selectedSkills = [];
  bool _isLoading = false;

  // Available skills for filtering
  final List<String> _availableSkills = [
    'UI/UX Design',
    'Web Development',
    'Mobile Development',
    'Graphic Design',
    'Content Writing',
    'Video Editing',
    'Marketing',
    'Data Analysis',
    'Machine Learning',
    'Photography',
    'Illustration',
    'Animation',
    'SEO',
  ];

  List<Gig> get gigs => _gigs;
  String get searchQuery => _searchQuery;
  List<String> get selectedSkills => _selectedSkills;
  List<String> get availableSkills => _availableSkills;
  bool get isLoading => _isLoading;

  List<Gig> get filteredGigs {
    List<Gig> filtered = _gigs;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((gig) =>
              gig.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              gig.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              gig.requiredSkills.any((skill) =>
                  skill.toLowerCase().contains(_searchQuery.toLowerCase())))
          .toList();
    }

    // Filter by selected skills
    if (_selectedSkills.isNotEmpty) {
      filtered = filtered
          .where((gig) => gig.requiredSkills
              .any((skill) => _selectedSkills.contains(skill)))
          .toList();
    }

    return filtered;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleSkillFilter(String skill) {
    if (_selectedSkills.contains(skill)) {
      _selectedSkills.remove(skill);
    } else {
      _selectedSkills.add(skill);
    }
    notifyListeners();
  }

  void clearSkillFilters() {
    _selectedSkills.clear();
    notifyListeners();
  }

  void addGig(Gig gig) {
    _gigs.insert(0, gig);
    notifyListeners();
  }

  void toggleBookmark(String gigId) {
    final gigIndex = _gigs.indexWhere((gig) => gig.id == gigId);
    if (gigIndex != -1) {
      _gigs[gigIndex] = _gigs[gigIndex].copyWith(
        isBookmarked: !_gigs[gigIndex].isBookmarked,
      );
      notifyListeners();
    }
  }

  void applyForGig(String gigId) {
    // Implementation for applying to a gig
    // This would typically involve API calls
    print('Applied for gig: $gigId');
  }

  Future<void> refreshGigs() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }
}

// Main GigBoard Screen
class GigBoardScreen extends StatefulWidget {
  @override
  _GigBoardScreenState createState() => _GigBoardScreenState();
}

class _GigBoardScreenState extends State<GigBoardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GigBoardProvider(),
      child: Scaffold(
        backgroundColor: Color(0xFF0A1628),
        appBar: _buildAppBar(),
        body: Consumer<GigBoardProvider>(
          builder: (context, gigProvider, child) {
            return RefreshIndicator(
              onRefresh: gigProvider.refreshGigs,
              backgroundColor: Color(0xFF1A2332),
              color: Color(0xFFFFC107),
              child: Column(
                children: [
                  _buildSearchAndFilter(gigProvider),
                  if (_showFilters) _buildSkillFilters(gigProvider),
                  _buildGigList(gigProvider),
                ],
              ),
            );
          },
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xFF0A1628),
      elevation: 0,
      title: FadeTransition(
        opacity: _animationController,
        child: Column(
          children: [
            SizedBox(height: 20,),
            Text(
              'GigBoard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      //
    );
  }

  Widget _buildSearchAndFilter(GigBoardProvider gigProvider) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF1A2332),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: gigProvider.setSearchQuery,
                style:
                    TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                decoration: InputDecoration(
                    hintText: 'Search gigs...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey[400]),
                            onPressed: () {
                              _searchController.clear();
                              gigProvider.setSearchQuery('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    filled: true,
                    fillColor: const Color(0xFF0A1628)),
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: _showFilters ? Color(0xFFFFC107) : Color(0xFF1A2332),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.tune,
                color: _showFilters ? Colors.black : Colors.grey[400],
              ),
              onPressed: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillFilters(GigBoardProvider gigProvider) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 5),
      decoration: BoxDecoration(
        color: Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter by skills',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: gigProvider.clearSkillFilters,
                child: Text(
                  'Clear',
                  style: TextStyle(color: Color(0xFFFFC107)),
                ),
              ),
            ],
          ),
          SizedBox(height: 3),
          // Add scrollable container for skills
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 90, // Limit the height to make it scrollable
            ),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: gigProvider.availableSkills.map((skill) {
                  final isSelected = gigProvider.selectedSkills.contains(skill);
                  return GestureDetector(
                    onTap: () => gigProvider.toggleSkillFilter(skill),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? Color(0xFFFFC107) : Color(0xFF2A3441),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Color(0xFFFFC107)
                              : Colors.grey[700]!,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        skill,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.grey[300],
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGigList(GigBoardProvider gigProvider) {
    if (gigProvider.isLoading) {
      return Expanded(child: _buildShimmerLoading());
    }

    final gigs = gigProvider.filteredGigs;

    if (gigs.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.work_off,
                size: 64,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                'No gigs found',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18,
                ),
              ),
              if (gigProvider.selectedSkills.isNotEmpty) ...[
                SizedBox(height: 8),
                Text(
                  'Try adjusting your filters',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: gigs.length,
        itemBuilder: (context, index) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                index * 0.1,
                1.0,
                curve: Curves.easeOutCubic,
              ),
            )),
            child: GigCard(
              gig: gigs[index],
              onTap: () => _showGigDetails(gigs[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          child: Shimmer.fromColors(
            baseColor: Color(0xFF1A2332),
            highlightColor: Color(0xFF2A3441),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Color(0xFF1A2332),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFC107),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFC107).withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(Icons.add, color: Colors.black, size: 28),
        onPressed: () => _showPostGigScreen(),
      ),
    );
  }

  void _showGigDetails(Gig gig) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GigDetailsScreen(gig: gig),
      ),
    );
  }

  void _showPostGigScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostGigScreen(),
      ),
    );
  }
}

// Gig Card Widget
class GigCard extends StatelessWidget {
  final Gig gig;
  final VoidCallback? onTap;

  const GigCard({Key? key, required this.gig, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF1A2332),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[800]!, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 12),
                _buildDescription(),
                SizedBox(height: 16),
                _buildBudgetAndDeadline(),
                SizedBox(height: 16),
                _buildSkills(),
                SizedBox(height: 16),
                _buildPosterInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            gig.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            gig.status,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      gig.description,
      style: TextStyle(
        color: Colors.grey[300],
        fontSize: 14,
        height: 1.4,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildBudgetAndDeadline() {
    return Row(
      children: [
        Icon(Icons.attach_money, color: Color(0xFFFFC107), size: 20),
        Text(
          '\$${gig.budget}',
          style: TextStyle(
            color: Color(0xFFFFC107),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 20),
        Icon(Icons.access_time, color: Colors.grey[400], size: 20),
        SizedBox(width: 4),
        Text(
          gig.deadline,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        Spacer(),
        Text(
          timeago.format(gig.createdAt),
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSkills() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: gig.requiredSkills
          .map((skill) => Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF2A3441),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[700]!, width: 0.5),
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 12,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildPosterInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Color(0xFFFFC107),
          child: Text(
            gig.postedBy[0].toUpperCase(),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Posted by',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
            Text(
              gig.postedBy,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (gig.status.toLowerCase()) {
      case 'open':
        return Color(0xFF2ECC71);
      case 'in progress':
        return Color(0xFFF39C12);
      case 'completed':
        return Color(0xFF3498DB);
      default:
        return Color(0xFF95A5A6);
    }
  }
}

// Gig Details Screen
class GigDetailsScreen extends StatelessWidget {
  final Gig gig;

  const GigDetailsScreen({Key? key, required this.gig}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: Color(0xFF0A1628),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Gig Details',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Share functionality
            },
          ),
          Consumer<GigBoardProvider>(
            builder: (context, gigProvider, child) {
              return IconButton(
                icon: Icon(
                  gig.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: gig.isBookmarked ? Color(0xFFFFC107) : Colors.white,
                ),
                onPressed: () => gigProvider.toggleBookmark(gig.id),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    gig.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFF2ECC71),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    gig.status,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Budget and Deadline Cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF1A2332),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.attach_money,
                            color: Color(0xFFFFC107), size: 32),
                        SizedBox(height: 8),
                        Text(
                          '\$${gig.budget}',
                          style: TextStyle(
                            color: Color(0xFFFFC107),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Budget',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF1A2332),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.access_time,
                            color: Colors.grey[400], size: 32),
                        SizedBox(height: 8),
                        Text(
                          gig.deadline,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Deadline',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Description Section
            Text(
              'Description',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              gig.description,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 16,
                height: 1.5,
              ),
            ),

            SizedBox(height: 24),

            // Required Skills Section
            Text(
              'Required Skills',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: gig.requiredSkills
                  .map((skill) => Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFF2A3441),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          skill,
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
            ),

            SizedBox(height: 24),

            // Posted By Section
            Text(
              'Posted By',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF1A2332),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFFFFC107),
                    child: Text(
                      gig.postedBy[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gig.postedBy,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          gig.posterUniversity,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFC107),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Contact',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Consumer<GigBoardProvider>(
          builder: (context, gigProvider, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  gigProvider.applyForGig(gig.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Applied for gig successfully!'),
                      backgroundColor: Color(0xFF2ECC71),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFC107),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Apply for this Gig',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),

    );
  }
}

// Post Gig Screen
class PostGigScreen extends StatefulWidget {
  @override
  _PostGigScreenState createState() => _PostGigScreenState();
}

class _PostGigScreenState extends State<PostGigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();
  final _deadlineController = TextEditingController();

  List<String> _selectedSkills = [];
  final List<String> _availableSkills = [
    'UI/UX Design',
    'Web Development',
    'Mobile Development',
    'Graphic Design',
    'Content Writing',
    'Video Editing',
    'Marketing',
    'Data Analysis',
    'Machine Learning',
    'Photography',
    'Illustration',
    'Animation',
    'SEO',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: Color(0xFF0A1628),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Post a Gig',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Post a New Gig',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Find the perfect collaborator for your project',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 32),

              // Gig Title
              Text(
                'Gig Title',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter a clear, descriptive title',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  filled: true,
                  fillColor: Color(0xFF1A2332),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFFFC107), width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),

              SizedBox(height: 24),

              // Description
              Text(
                'Description',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                style: TextStyle(color: Colors.white),
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      'Describe the project, requirements, and expectations',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  filled: true,
                  fillColor: Color(0xFF1A2332),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFFFC107), width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),

              SizedBox(height: 24),

              // Budget and Deadline Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Budget',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _budgetController,
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Amount',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            prefixText: '\$ ',
                            prefixStyle: TextStyle(color: Color(0xFFFFC107)),
                            filled: true,
                            fillColor: Color(0xFF1A2332),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Color(0xFFFFC107), width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter budget';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deadline',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _deadlineController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'e.g. 2 weeks',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            prefixIcon: Icon(Icons.access_time,
                                color: Colors.grey[500]),
                            filled: true,
                            fillColor: Color(0xFF1A2332),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Color(0xFFFFC107), width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter deadline';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Required Skills
              Text(
                'Required Skills',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Select up to 5 skills',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableSkills.map((skill) {
                  final isSelected = _selectedSkills.contains(skill);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedSkills.remove(skill);
                        } else if (_selectedSkills.length < 5) {
                          _selectedSkills.add(skill);
                        }
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? Color(0xFFFFC107) : Color(0xFF2A3441),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Color(0xFFFFC107)
                              : Colors.grey[700]!,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        skill,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.grey[300],
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate() &&
                  _selectedSkills.isNotEmpty) {
                final newGig = Gig(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: _titleController.text,
                  description: _descriptionController.text,
                  budget: int.tryParse(_budgetController.text) ?? 0,
                  deadline: _deadlineController.text,
                  requiredSkills: _selectedSkills,
                  postedBy: 'You',
                  posterUniversity: 'Your University',
                  status: 'Open',
                  createdAt: DateTime.now(),
                );

                // Add to provider if available
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gig posted successfully!'),
                    backgroundColor: Color(0xFF2ECC71),
                  ),
                );
              } else if (_selectedSkills.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please select at least one skill'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFC107),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Post Gig',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ),

    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }
}
