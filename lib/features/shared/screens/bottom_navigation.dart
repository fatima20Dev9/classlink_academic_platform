import 'package:flutter/material.dart';

// import '../../auth/screens/login_screen.dart';
import 'all_enrolled_courses.dart';
import 'home.dart';
import 'profile.dart';
import 'tab_chat.dart';

class BottomNavigationPage extends StatefulWidget {
  final String role;

  const BottomNavigationPage({super.key, required this.role});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    final safeRole = widget.role;
    _pages = [
      HomePage(role: safeRole),
      const AllEnrolledCoursesPage(showAppBar: false,),
      const ChatPage(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: _pages),
      ),

      // Bottom Navigation
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              );
            }
            return TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7));
          }),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return IconThemeData(color: Theme.of(context).colorScheme.primary, size: 28);
            }
            return IconThemeData(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), size: 24);
          }),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() => _selectedIndex = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view),
              label: 'Courses',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(Icons.chat_bubble),
              label: 'Chats',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
