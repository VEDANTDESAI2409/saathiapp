import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../core/widgets/pill_bottom_nav.dart';
import '../core/widgets/custom_app_bar.dart';
import '../providers/auth_provider.dart';
import '../providers/city_provider.dart';
import '../providers/post_provider.dart';
import '../providers/notification_provider.dart';
import 'home/home_screen.dart';
import 'explore/explore_screen.dart';
import 'activity/activity_screen.dart';
import 'profile/profile_screen.dart';
import 'create/create_choice_modal.dart';
import 'profile/notification_settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialFetch();
    });
  }

  void _initialFetch() {
    final cityProvider = Provider.of<CityProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final notifProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );

    final preferredCity = cityProvider.selectedCity;
    final user = authProvider.currentUser;

    postProvider.fetchHomePosts(preferredCity: preferredCity);
    postProvider.fetchExplorePosts();

    if (user != null) {
      postProvider.fetchMonthlyUsage(user.id);
      postProvider.fetchUserReservations(user.id);
      notifProvider.fetchNotifications(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreen(),
      const ExploreScreen(),
      const SizedBox.shrink(), // Index 2 is Create button trigger
      const ActivityScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: CustomAppBar(
        onNotificationTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NotificationSettingsScreen(),
            ),
          );
        },
        onProfileTap: () {
          setState(() => _currentIndex = 4);
        },
      ),
      body: IndexedStack(
        index: _currentIndex == 2 ? 0 : _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: PillBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != 2) {
            setState(() => _currentIndex = index);
          }
        },
        onCreateTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const CreateChoiceModal(),
          );
        },
      ),
    );
  }
}
