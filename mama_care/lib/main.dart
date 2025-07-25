// Importing necessary Flutter packages and app pages.
import 'package:firebase_core/firebase_core.dart';
import 'package:mama_care/Pages/signup_page.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:mama_care/Pages/login.dart';
import 'package:mama_care/Pages/home.dart';
import 'package:mama_care/utilities/reminders.dart';
import 'package:mama_care/services/clinics.dart';
import 'package:mama_care/Pages/ai_chat_page.dart';
import 'package:mama_care/Pages/user_profile.dart';
import 'package:mama_care/utilities/settings.dart';
import 'package:mama_care/utilities/firebase_debug.dart';
import 'package:mama_care/constants/app_colors.dart';

// Entry point of the application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Debug Firebase status
  FirebaseDebugger.printFirebaseStatus();
  runApp(const MamaCareApp());
}

// Root widget of the Mama Care app
class MamaCareApp extends StatelessWidget {
  const MamaCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner in the top-right corner.
      title: 'Mama Care', // App title
      theme: AppTheme.lightTheme, // Using centralized theme configuration
      initialRoute: '/', // Initial route when the app starts
      routes: {
        '/': (context) => const LoginPage(), // Login page as the initial screen
        '/login': (context) => const LoginPage(), // Explicit login route
        '/signup': (context) => const SignUpPage(), // Registration page
        '/home': (context) => const HomePageContainer(), // Main home page with navigation
        '/aichat': (context) => AIChatPage(), // AI Chat page
        '/settings': (context) => const SettingsPage(), // Settings page
        '/profile': (context) => const ProfilePage(), // Profile page
        '/reminders': (context) => const RemindersPage(), // Reminders page
        '/clinics': (context) => const ClinicsPage(), // Clinics page
      },
    );
  }
}

// Stateful widget to manage the bottom navigation and main pages
class HomePageContainer extends StatefulWidget {
  const HomePageContainer({super.key});

  @override
  State<HomePageContainer> createState() => _HomePageContainerState();
}

class _HomePageContainerState extends State<HomePageContainer> {
  int _selectedIndex = 0; // Tracks the currently selected tab

  // List of widgets for each tab in the bottom navigation
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    AIChatPage(),
    RemindersPage(),
    ClinicsPage(),
    ProfilePage(),
  ];

  // Updates the selected tab index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mama Care'), // App bar title
        backgroundColor: AppColors.primary, // App bar color using centralized colors
        elevation: 0, // Removes shadow
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20), // Rounded bottom corners
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex), // Displays the selected page
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined),
            label: 'AI Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Reminders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Clinics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, // Highlights the selected tab
        selectedItemColor: AppColors.primary, // Color for selected tab using centralized colors
        unselectedItemColor: AppColors.textLight, // Color for unselected tabs using centralized colors
        onTap: _onItemTapped, // Handles tab selection
        type: BottomNavigationBarType.fixed, // Fixed navigation bar
        backgroundColor: AppColors.background, // Navigation bar background using centralized colors
        elevation: 10, // Navigation bar shadow
      ),
    );
  }
}
