import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:vertex_app/app.dart';
import 'package:vertex_app/screens/mentor_link_screen.dart';
import 'package:vertex_app/screens/home_screen.dart';
import 'package:vertex_app/screens/profile_screen.dart';
import 'package:vertex_app/screens/quick_match_tab.dart';
import 'package:vertex_app/splash_screen.dart';
import 'features/MentorLink/model/Mentor_model.dart';
import 'features/authentication/auth_manager.dart';
import 'features/authentication/presentation/signin_page.dart';
import 'screens/gig_board_screen.dart';
import 'firebase_options.dart';

void main() async {
  // Initialize splash screen settings
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthManager()),
        ChangeNotifierProvider(create: (_) => GigBoardProvider()),
        ChangeNotifierProvider(create: (_) => MentorLinkProvider()),
        // Other providers
      ],
      child: const VertexApp(),
    ),
  );
}

class AuthHandler extends StatelessWidget {
  const AuthHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthManager>(
      builder: (context, authManager, _) {
        if (authManager.status == AuthStatus.initial) {
          return const SplashScreenHandler();
        }

        return authManager.isAuthenticated
            ? const DashboardScreen()
            : const SignInPage();
      },
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const QuickMatchTab(),
    const GigBoardScreen(),
    const MentorLink(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFF001232),
          selectedItemColor: Color(0xFFFFC500),
          unselectedItemColor: Colors.white,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'QuickMatch', // Changed from 'Connect'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline),
              activeIcon: Icon(Icons.work),
              label: 'GigBoard', // Changed from 'Projects'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              activeIcon: Icon(Icons.school),
              label: 'MentorLink', // Changed from 'Entertainment'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile', // Changed from 'Career'
            ),
          ],
        ),
      ),
    );
  }
}
