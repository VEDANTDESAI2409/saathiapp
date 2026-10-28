import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/city_provider.dart';
import '../../providers/post_provider.dart';
import 'edit_profile_screen.dart';
import 'personal_impact_screen.dart';
import 'verification_status_screen.dart';
import 'monthly_limit_screen.dart';
import 'helpline_screen.dart';
import 'safety_center_screen.dart';
import 'notification_settings_screen.dart';
import 'language_settings_screen.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cityProvider = Provider.of<CityProvider>(context);
    final postProvider = Provider.of<PostProvider>(context);

    final user = authProvider.currentUser;
    final city = cityProvider.selectedCity;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // User Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.trustTeal,
                      backgroundImage:
                          (user != null && user.avatarUrl.isNotEmpty)
                          ? NetworkImage(user.avatarUrl)
                          : null,
                      child: (user == null || user.avatarUrl.isEmpty)
                          ? Text(
                              user?.name.isNotEmpty == true
                                  ? user!.name[0].toUpperCase()
                                  : 'S',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                user?.name ?? 'Community Member',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.deepForest,
                                ),
                              ),
                              if (user?.isVerified == true) ...[
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.verified,
                                  color: AppColors.trustTeal,
                                  size: 18,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.email ?? '',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.softMint,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Preferred City: $city',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.trustTeal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.trustTeal,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),

                // Helps Done / Taken Summary Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _countCol('Helps Done', '${user?.helpsDoneCount ?? 0}'),
                    Container(height: 24, width: 1, color: AppColors.border),
                    _countCol('Helps Taken', '${user?.helpsTakenCount ?? 0}'),
                    Container(height: 24, width: 1, color: AppColors.border),
                    _countCol(
                      'Private Score',
                      '${user?.contributionScore ?? 0}',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Preferred City Card Selector (Requirement 15)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_city, color: AppColors.trustTeal),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Registered Preferred City',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        city,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepForest,
                        ),
                      ),
                    ],
                  ),
                ),
                DropdownButton<String>(
                  underline: const SizedBox.shrink(),
                  icon: const Icon(
                    Icons.swap_horiz,
                    color: AppColors.trustTeal,
                  ),
                  items: AppConstants.supportedCities.map((c) {
                    return DropdownMenuItem(value: c, child: Text(c));
                  }).toList(),
                  onChanged: (newCity) async {
                    if (newCity != null) {
                      cityProvider.setCity(newCity);
                      await authProvider.setRegisteredCity(newCity);
                      await postProvider.fetchHomePosts(preferredCity: newCity);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Preferred city updated to $newCity! Home feed refreshed.',
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Menu List
          _menuItem(
            icon: Icons.edit_note,
            title: 'Edit Profile & City',
            subtitle: 'Update name, mobile, email, and preferred city',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
          ),
          _menuItem(
            icon: Icons.pie_chart_outline_rounded,
            title: 'Personal Impact Dashboard',
            subtitle: 'View contribution score breakdown and category impact',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PersonalImpactScreen()),
              );
            },
          ),
          _menuItem(
            icon: Icons.verified_user_outlined,
            title: 'Identity Verification Status',
            subtitle: user?.isVerified == true
                ? 'Verified Member'
                : 'Pending Review / Unverified',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const VerificationStatusScreen(),
                ),
              );
            },
          ),
          _menuItem(
            icon: Icons.speed_rounded,
            title: 'Monthly Help Limit & Exception',
            subtitle: 'Track 15 monthly instances or request exception',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MonthlyLimitScreen()),
              );
            },
          ),
          _menuItem(
            icon: Icons.headset_mic_outlined,
            title: 'Management Helpline & Support',
            subtitle: 'Escalate emergency needs or technical issues',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelplineScreen()),
              );
            },
          ),
          _menuItem(
            icon: Icons.shield_outlined,
            title: 'Safety Center',
            subtitle: 'View submitted reports and blocked users',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SafetyCenterScreen()),
              );
            },
          ),
          _menuItem(
            icon: Icons.notifications_none_rounded,
            title: 'Notification Preferences',
            subtitle: 'Control emergency alerts and category updates',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationSettingsScreen(),
                ),
              );
            },
          ),
          _menuItem(
            icon: Icons.language_rounded,
            title: 'Language Settings',
            subtitle: 'English / ગુજરાતી / हिन्दी',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LanguageSettingsScreen(),
                ),
              );
            },
          ),

          // Requirement 17: Admin Operations entry removed from Profile menu
          const SizedBox(height: 12),

          // Log Out Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.emergencyRed,
                side: const BorderSide(color: AppColors.emergencyRed),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.logout),
              label: const Text('Log Out of SaathiApp'),
              onPressed: () async {
                await authProvider.logout();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _countCol(String label, String val) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.trustTeal,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.trustTeal),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.deepForest,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textMuted,
          size: 20,
        ),
        onTap: onTap,
      ),
    );
  }
}
