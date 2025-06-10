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
