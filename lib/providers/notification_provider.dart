import 'package:flutter/material.dart';

import '../data/models/notification_model.dart';
import '../data/models/preferences_model.dart';
import '../data/repositories/notification_repository.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _repository = NotificationRepository();

  List<NotificationModel> _notifications = [];
  UserPreferencesModel? _preferences;
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  UserPreferencesModel? get preferences => _preferences;
  bool get isLoading => _isLoading;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> fetchNotifications(String userId) async {
    _isLoading = true;
    notifyListeners();

    _notifications = await _repository.getNotifications(userId);
    _preferences = await _repository.getPreferences(userId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> markAsRead(String id) async {
    await _repository.markAsRead(id);
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx] = NotificationModel(
        id: _notifications[idx].id,
        userId: _notifications[idx].userId,
        title: _notifications[idx].title,
        body: _notifications[idx].body,
        type: _notifications[idx].type,
        relatedEntityId: _notifications[idx].relatedEntityId,
        timestamp: _notifications[idx].timestamp,
        isRead: true,
      );
      notifyListeners();
    }
  }

  Future<void> savePreferences(UserPreferencesModel prefs) async {
    await _repository.savePreferences(prefs);
    _preferences = prefs;
    notifyListeners();
  }
}
