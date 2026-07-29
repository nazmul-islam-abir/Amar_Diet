import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_theme.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_bottom_nav.dart';
import 'home_dashboard.dart';
import 'food_browse_screen.dart';
import 'log_meal_screen.dart';
import 'progress_screen.dart';
import 'profile_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _screens = [
    HomeDashboard(),
    FoodBrowseScreen(),
    LogMealScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackNavigation();
      },
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(index: _index, children: _screens),
        bottomNavigationBar: GlassBottomNav(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
        ),
      ),
    );
  }

  void _handleBackNavigation() async {
    // 1. If not on the Home tab, go to the Home tab first
    if (_index != 0) {
      setState(() => _index = 0);
      return;
    }

    // 2. Already on Home tab, show the professional exit dialog
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: const Text('Exit Amar Diet?'),
        content: const Text('Are you sure you want to close the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.secondary),
            child: const Text('Yes, Exit'),
          ),
        ],
      ),
    );

    if (shouldExit == true) {
      SystemNavigator.pop();
    }
  }
}
