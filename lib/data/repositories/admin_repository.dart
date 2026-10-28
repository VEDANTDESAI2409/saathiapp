import 'package:sqflite/sqflite.dart';

import '../database/db_helper.dart';
import '../models/verification_model.dart';
import '../models/report_model.dart';

class AdminRepository {
  Future<Map<String, int>> getOperationalMetrics() async {
    final db = await DBHelper.database;

    final openNeeds =
        Sqflite.firstIntValue(
          await db.rawQuery(
            "SELECT COUNT(*) FROM posts WHERE type = 'need' AND status = 'open'",
          ),
        ) ??
        0;
    final openOffers =
        Sqflite.firstIntValue(
          await db.rawQuery(
            "SELECT COUNT(*) FROM posts WHERE type = 'offer' AND status = 'open'",
          ),
        ) ??
        0;
    final emergencies =
        Sqflite.firstIntValue(
          await db.rawQuery(
            "SELECT COUNT(*) FROM posts WHERE priority = 'emergency' AND status = 'open'",
          ),
        ) ??
        0;
    final pendingVerifications =
        Sqflite.firstIntValue(
          await db.rawQuery(
            "SELECT COUNT(*) FROM verifications WHERE status = 'pending'",
          ),
        ) ??
        0;
    final activeReports =
        Sqflite.firstIntValue(
          await db.rawQuery(
            "SELECT COUNT(*) FROM reports WHERE status = 'pending'",
          ),
        ) ??
        0;
    final completedHelp =
        Sqflite.firstIntValue(
          await db.rawQuery(
            "SELECT COUNT(*) FROM reservations WHERE status = 'completed'",
          ),
        ) ??
        0;

    return {
      'openNeeds': openNeeds,
      'openOffers': openOffers,
      'emergencies': emergencies,
      'pendingVerifications': pendingVerifications,
      'activeReports': activeReports,
      'completedHelp': completedHelp,
    };
  }

  Future<List<VerificationSubmissionModel>> getVerificationQueue() async {
    final db = await DBHelper.database;
    final maps = await db.query('verifications', orderBy: 'submittedAt DESC');
    return maps.map((m) => VerificationSubmissionModel.fromMap(m)).toList();
  }

  Future<void> reviewVerification(
    String id,
    String status,
    String notes,
  ) async {
    final db = await DBHelper.database;
    await db.update(
      'verifications',
      {'status': status, 'adminNotes': notes},
      where: 'id = ?',
      whereArgs: [id],
    );

    // If approved, update user's verification flag
    final vMap = await db.query(
      'verifications',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (vMap.isNotEmpty && status == 'approved') {
      final userId = vMap.first['userId'] as String;
      await db.update(
        'users',
        {'isVerified': 1, 'verificationStatus': 'approved'},
        where: 'id = ?',
        whereArgs: [userId],
      );
    }
  }

  Future<void> submitVerification(VerificationSubmissionModel sub) async {
    final db = await DBHelper.database;
    await db.insert(
      'verifications',
      sub.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.update(
      'users',
      {'verificationStatus': 'pending'},
      where: 'id = ?',
      whereArgs: [sub.userId],
    );
  }

  Future<void> submitReport(ReportModel report) async {
    final db = await DBHelper.database;
    await db.insert(
      'reports',
      report.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ReportModel>> getReports() async {
    final db = await DBHelper.database;
    final maps = await db.query('reports', orderBy: 'timestamp DESC');
    return maps.map((m) => ReportModel.fromMap(m)).toList();
  }

  Future<void> blockUser(String userId, String blockedUserId) async {
    final db = await DBHelper.database;
    await db.insert('blocked_users', {
      'userId': userId,
      'blockedUserId': blockedUserId,
      'timestamp': DateTime.now().toIso8601String().split('.').first,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<String>> getBlockedUsers(String userId) async {
    final db = await DBHelper.database;
    final maps = await db.query(
      'blocked_users',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return maps.map((m) => m['blockedUserId'] as String).toList();
  }
}
