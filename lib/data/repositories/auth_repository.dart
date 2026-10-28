import 'package:shared_preferences/shared_preferences.dart';

import '../database/db_helper.dart';
import '../models/user_model.dart';

class AuthRepository {
  static const String _keyCurrentUserId = 'current_user_id';

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(_keyCurrentUserId);
    userId ??= 'user_current'; // default demo user

    final db = await DBHelper.database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [userId]);

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<void> setCurrentUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCurrentUserId, userId);
  }

  Future<UserModel> updateRegisteredCity(String userId, String city) async {
    final db = await DBHelper.database;
    await db.update(
      'users',
      {'registeredCity': city},
      where: 'id = ?',
      whereArgs: [userId],
    );

    final user = await getCurrentUser();
    return user!;
  }

  Future<UserModel> updateUserProfile(UserModel updatedUser) async {
    final db = await DBHelper.database;
    await db.update(
      'users',
      updatedUser.toMap(),
      where: 'id = ?',
      whereArgs: [updatedUser.id],
    );
    return updatedUser;
  }

  Future<UserModel> loginUser(String identifier, String password) async {
    final db = await DBHelper.database;
    final maps = await db.query(
      'users',
      where: 'email = ? OR phone = ? OR id = ?',
      whereArgs: [identifier, identifier, identifier],
    );

    if (maps.isNotEmpty) {
      final user = UserModel.fromMap(maps.first);
      await setCurrentUser(user.id);
      return user;
    }

    // If new login, create a new user account
    final newUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: identifier.contains('@')
          ? identifier.split('@').first
          : 'Community Member',
      phone: identifier.contains('@') ? '+91 98000 00000' : identifier,
      email: identifier.contains('@')
          ? identifier
          : '$identifier@saathiapp.org',
      registeredCity: 'Ahmedabad',
      createdAt: DateTime.now().toIso8601String().split('T').first,
    );

    await db.insert('users', newUser.toMap());
    await setCurrentUser(newUser.id);
    return newUser;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCurrentUserId);
  }
}
