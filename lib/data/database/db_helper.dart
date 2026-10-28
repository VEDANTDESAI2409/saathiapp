import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import 'seed_data.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'saathiapp.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id TEXT PRIMARY KEY,
            name TEXT,
            phone TEXT,
            email TEXT,
            registeredCity TEXT,
            avatarUrl TEXT,
            isVerified INTEGER,
            verificationStatus TEXT,
            contributionScore INTEGER,
            helpsDoneCount INTEGER,
            helpsTakenCount INTEGER,
            role TEXT,
            createdAt TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE posts (
            id TEXT PRIMARY KEY,
            userId TEXT,
            userName TEXT,
            userAvatar TEXT,
            userIsVerified INTEGER,
            type TEXT,
            title TEXT,
            description TEXT,
            categoryId TEXT,
            categoryName TEXT,
            priority TEXT,
            totalQuantity INTEGER,
            remainingQuantity INTEGER,
            city TEXT,
            areaName TEXT,
            durationText TEXT,
            expiresAt TEXT,
            status TEXT,
            mediaUrls TEXT,
            contactInstructions TEXT,
            isClosedEarly INTEGER,
            createdAt TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE reservations (
            id TEXT PRIMARY KEY,
            postId TEXT,
            postTitle TEXT,
            postType TEXT,
            categoryName TEXT,
            postOwnerId TEXT,
            postOwnerName TEXT,
            reservedById TEXT,
            reservedByName TEXT,
            reservedQuantity INTEGER,
            status TEXT,
            note TEXT,
            createdAt TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE evidence (
            id TEXT PRIMARY KEY,
            reservationId TEXT,
            postId TEXT,
            uploadedByUserId TEXT,
            uploadedByUserName TEXT,
            userRole TEXT,
            photoUrl TEXT,
            description TEXT,
            timestamp TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE chat_messages (
            id TEXT PRIMARY KEY,
            conversationId TEXT,
            senderId TEXT,
            senderName TEXT,
            receiverId TEXT,
            text TEXT,
            timestamp TEXT,
            isRead INTEGER,
            containsContactDetails INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE notifications (
            id TEXT PRIMARY KEY,
            userId TEXT,
            title TEXT,
            body TEXT,
            type TEXT,
            relatedEntityId TEXT,
            timestamp TEXT,
            isRead INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE verifications (
            id TEXT PRIMARY KEY,
            userId TEXT,
            userName TEXT,
            documentType TEXT,
            documentNumber TEXT,
            documentFrontUrl TEXT,
            documentBackUrl TEXT,
            status TEXT,
            adminNotes TEXT,
            submittedAt TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE monthly_usages (
            userId TEXT,
            yearMonth TEXT,
            count INTEGER,
            limitVal INTEGER,
            exceptionRequested INTEGER,
            exceptionReason TEXT,
            exceptionStatus TEXT,
            PRIMARY KEY (userId, yearMonth)
          )
        ''');

        await db.execute('''
          CREATE TABLE reports (
            id TEXT PRIMARY KEY,
            reporterId TEXT,
            targetType TEXT,
            targetId TEXT,
            targetTitle TEXT,
            reason TEXT,
            details TEXT,
            timestamp TEXT,
            status TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE blocked_users (
            userId TEXT,
            blockedUserId TEXT,
            timestamp TEXT,
            PRIMARY KEY (userId, blockedUserId)
          )
        ''');

        await db.execute('''
          CREATE TABLE followed_posts (
            userId TEXT,
            postId TEXT,
            timestamp TEXT,
            PRIMARY KEY (userId, postId)
          )
        ''');

        await db.execute('''
          CREATE TABLE preferences (
            userId TEXT PRIMARY KEY,
            emergencyAlerts INTEGER,
            categoryUpdates INTEGER,
            reservationAlerts INTEGER,
            chatMessages INTEGER,
            communityBanners INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE categories (
            id TEXT PRIMARY KEY,
            name TEXT,
            iconName TEXT,
            description TEXT,
            activeNeedsCount INTEGER,
            activeOffersCount INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE banners (
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            imageUrl TEXT,
            actionType TEXT,
            actionPayload TEXT,
            isActive INTEGER
          )
        ''');

        // Seed initial data
        await SeedData.populateSeedData(db);
      },
    );
  }
}
