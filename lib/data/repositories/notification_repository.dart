import 'package:sqflite/sqflite.dart';

import '../database/db_helper.dart';
import '../models/notification_model.dart';
import '../models/preferences_model.dart';

class NotificationRepository {
  Future<List<NotificationModel>> getNotifications(String userId) async {
    final db = await DBHelper.database;
    final maps = await db.query(
      'notifications',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
    );
    return maps.map((m) => NotificationModel.fromMap(m)).toList();
  }

  Future<void> markAsRead(String notificationId) async {
    final db = await DBHelper.database;
    await db.update(
      'notifications',
      {'isRead': 1},
      where: 'id = ?',
      whereArgs: [notificationId],
    );
  }

  Future<UserPreferencesModel> getPreferences(String userId) async {
    final db = await DBHelper.database;
    final maps = await db.query(
      'preferences',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return UserPreferencesModel.fromMap(maps.first);
    }

    final newPref = UserPreferencesModel(userId: userId);
    await db.insert('preferences', newPref.toMap());
    return newPref;
  }

  Future<void> savePreferences(UserPreferencesModel prefs) async {
    final db = await DBHelper.database;
    await db.insert(
      'preferences',
      prefs.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
