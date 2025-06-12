class QuickMatchModel {
  final String imageLink;
  final String name;
  final String college;
  final String description;
  final List<String> tags;

  QuickMatchModel({
    required this.imageLink,
    required this.name,
    required this.college,
    required this.description,
    required this.tags,
  });
}

List<QuickMatchModel> get quickMatchList => [
  QuickMatchModel(
    imageLink: 'assets/images/sample_mike_image.png',
    name: 'Alice',
    college: 'Harvard University',
    description: 'Software Developer specializing in Flutter and Dart.',
    tags: ['Flutter', 'Dart', 'Software Development'],
  ),
  QuickMatchModel(
    imageLink: 'assets/images/sample_mike_image.png',
    name: 'Diana',
    college: 'Princeton University',
    description: 'Data Scientist passionate about machine learning and analytics.',
    tags: ['Data Science', 'Machine Learning', 'Analytics'],
  ),
  QuickMatchModel(
    imageLink: 'assets/images/sample_mike_image.png',
    name: 'Ethan',
    college: 'Yale University',
    description: 'UI/UX Designer with a love for creating intuitive interfaces.',
    tags: ['UI/UX', 'Design', 'User Experience'],
  ),
  QuickMatchModel(
    imageLink: 'assets/images/sample_mike_image.png',
    name: 'Fiona',
    college: 'Columbia University',
    description: 'Cybersecurity expert focused on network security and privacy.',
    tags: ['Cybersecurity', 'Network Security', 'Privacy'],
  ),
  QuickMatchModel(
    imageLink: 'assets/images/sample_mike_image.png',
    name: 'Bob',
    college: 'Stanford University',
    description: 'Software Developer specializing in Flutter and Dart.',
    tags: ['Full Stack', 'Engineering','Software Development'],
  ),
  QuickMatchModel(
    imageLink: 'assets/images/sample_mike_image.png',
    name: 'Charlie',
    college: 'MIT',
    description: 'Robotics Engineer focused on AI and automation.',
    tags: ['Robotics', 'AI', 'Automation'],
  ),
];
