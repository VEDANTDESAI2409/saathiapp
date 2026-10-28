import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import '../constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/city_provider.dart';
import '../../providers/notification_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onNotificationTap;
  final VoidCallback onProfileTap;

  const CustomAppBar({
    super.key,
    required this.onNotificationTap,
    required this.onProfileTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cityProvider = Provider.of<CityProvider>(context);
    final notifProvider = Provider.of<NotificationProvider>(context);

    final user = authProvider.currentUser;
    final currentCity = cityProvider.selectedCity;
    final unreadCount = notifProvider.unreadCount;

    return AppBar(
      backgroundColor: AppColors.warmCream,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // App Logo
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.trustTeal,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.handshake_rounded,
              color: AppColors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'SaathiApp',
            style: TextStyle(
              color: AppColors.deepForest,
              fontSize: 19,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),

          // City Selector Chip
          InkWell(
            onTap: () => _showCityPicker(context, cityProvider, authProvider),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.softMint,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border, width: 0.8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 14,
                    color: AppColors.trustTeal,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    currentCity,
                    style: const TextStyle(
                      color: AppColors.deepForest,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    size: 16,
                    color: AppColors.deepForest,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Notification Icon with Badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.deepForest,
                ),
                onPressed: onNotificationTap,
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.emergencyRed,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),

          // User Avatar
          GestureDetector(
            onTap: onProfileTap,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.trustTeal,
              backgroundImage: (user != null && user.avatarUrl.isNotEmpty)
                  ? NetworkImage(user.avatarUrl)
                  : null,
              child: (user == null || user.avatarUrl.isEmpty)
                  ? Text(
                      user?.name.isNotEmpty == true
                          ? user!.name[0].toUpperCase()
                          : 'S',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  void _showCityPicker(
    BuildContext context,
    CityProvider cityProvider,
    AuthProvider authProvider,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Registered City',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepForest,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'SaathiApp matches needs and offers strictly within your registered city for safe mutual support.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: AppConstants.supportedCities.length,
                  itemBuilder: (context, i) {
                    final city = AppConstants.supportedCities[i];
                    final isSelected = city == cityProvider.selectedCity;
                    return ListTile(
                      title: Text(
                        city,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? AppColors.trustTeal
                              : AppColors.deepForest,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColors.trustTeal,
                            )
                          : null,
                      onTap: () {
                        cityProvider.setCity(city);
                        authProvider.setRegisteredCity(city);
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
