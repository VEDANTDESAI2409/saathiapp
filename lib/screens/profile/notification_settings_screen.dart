import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/notification_provider.dart';
import '../../providers/auth_provider.dart';
import '../../data/models/preferences_model.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifProvider = Provider.of<NotificationProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    final prefs =
        notifProvider.preferences ??
        UserPreferencesModel(userId: user?.id ?? '');

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(title: const Text('Notification Preferences')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SwitchListTile(
            title: const Text('Emergency Alerts'),
            subtitle: const Text(
              'Immediate alerts for emergency blood or medical needs in your city.',
            ),
            value: prefs.emergencyAlerts,
            onChanged: (val) {
              _updatePref(context, notifProvider, prefs, emergency: val);
            },
          ),
          SwitchListTile(
            title: const Text('Reservation & Status Alerts'),
            subtitle: const Text(
              'Notifications when someone reserves your post or updates help status.',
            ),
            value: prefs.reservationAlerts,
            onChanged: (val) {
              _updatePref(context, notifProvider, prefs, reservation: val);
            },
          ),
          SwitchListTile(
            title: const Text('Chat Message Notifications'),
            subtitle: const Text(
              'Alerts when you receive new coordination chat messages.',
            ),
            value: prefs.chatMessages,
            onChanged: (val) {
              _updatePref(context, notifProvider, prefs, chat: val);
            },
          ),
          SwitchListTile(
            title: const Text('Category & Community Banners'),
            subtitle: const Text(
              'Updates regarding community drives and winter clothing campaigns.',
            ),
            value: prefs.communityBanners,
            onChanged: (val) {
              _updatePref(context, notifProvider, prefs, banners: val);
            },
          ),
        ],
      ),
    );
  }

  void _updatePref(
    BuildContext context,
    NotificationProvider notifProvider,
    UserPreferencesModel current, {
    bool? emergency,
    bool? reservation,
    bool? chat,
    bool? banners,
  }) {
    final updated = UserPreferencesModel(
      userId: current.userId,
      emergencyAlerts: emergency ?? current.emergencyAlerts,
      reservationAlerts: reservation ?? current.reservationAlerts,
      chatMessages: chat ?? current.chatMessages,
      communityBanners: banners ?? current.communityBanners,
    );
    notifProvider.savePreferences(updated);
  }
}
