import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../core/constants/app_constants.dart';

class SeedData {
  static Future<void> populateSeedData(Database db) async {
    // 1. Categories
    for (var cat in AppConstants.predefinedCategories) {
      await db.insert('categories', {
        'id': cat['id'],
        'name': cat['name'],
        'iconName': cat['icon'],
        'description': cat['desc'],
        'activeNeedsCount': 2,
        'activeOffersCount': 2,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // 2. Banners (Helpline banner reads configured value)
    final banners = [
      {
        'id': 'banner_helpline',
        'title': 'Management Support Helpline',
        'description': 'Need immediate assistance or emergency coordination? Contact management support.',
        'imageUrl': 'https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?w=800',
        'actionType': 'helpline',
        'actionPayload': '',
        'isActive': 1,
      },
      {
        'id': 'banner_1',
        'title': 'Winter Clothing Drive',
        'description': 'Help warmth reach every family in Ahmedabad & Surat.',
        'imageUrl': 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=800',
        'actionType': 'category',
        'actionPayload': 'cat_clothing',
        'isActive': 1,
      },
      {
        'id': 'banner_2',
        'title': 'Emergency Food Relief',
        'description': 'Support daily wage workers and homeless shelters.',
        'imageUrl': 'https://images.unsplash.com/photo-1593113598332-cd288d649433?w=800',
        'actionType': 'category',
        'actionPayload': 'cat_food',
        'isActive': 1,
      },
      {
        'id': 'banner_3',
        'title': 'School Book Donation',
        'description': 'Donate textbooks to underprivileged students.',
        'imageUrl': 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=800',
        'actionType': 'category',
        'actionPayload': 'cat_books',
        'isActive': 1,
      },
    ];

    for (var b in banners) {
      await db.insert(
        'banners',
        b,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    // 3. Demo Users
    final users = [
      {
        'id': 'user_current',
        'name': 'Aarav Patel',
        'phone': 'Member Phone',
        'email': 'aarav.patel@saathiapp.org',
        'registeredCity': 'Ahmedabad',
        'avatarUrl': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
        'isVerified': 1,
        'verificationStatus': 'approved',
        'contributionScore': 240,
        'helpsDoneCount': 12,
        'helpsTakenCount': 3,
        'role': 'user',
        'createdAt': '2026-01-10',
      },
      {
        'id': 'user_meera',
        'name': 'Meera Shah',
        'phone': 'Member Phone',
        'email': 'meera@charitycare.org',
        'registeredCity': 'Ahmedabad',
        'avatarUrl':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
        'isVerified': 1,
        'verificationStatus': 'approved',
        'contributionScore': 450,
        'helpsDoneCount': 28,
        'helpsTakenCount': 1,
        'role': 'user',
        'createdAt': '2025-11-01',
      },
      {
        'id': 'user_surat_helper',
        'name': 'Rajesh Varma',
        'phone': 'Member Phone',
        'email': 'rajesh@suratcare.org',
        'registeredCity': 'Surat',
        'avatarUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
        'isVerified': 1,
        'verificationStatus': 'approved',
        'contributionScore': 310,
        'helpsDoneCount': 15,
        'helpsTakenCount': 2,
        'role': 'user',
        'createdAt': '2025-12-01',
      },
    ];

    for (var u in users) {
      await db.insert('users', u, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // 4. Initial Seed Posts
    final posts = [
      {
        'id': 'post_emergency_1',
        'userId': 'user_meera',
        'userName': 'Meera Shah',
        'userAvatar':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
        'userIsVerified': 1,
        'type': 'need',
        'title': 'Urgent O+ Blood / Dialysis Aid for Patient',
        'description': 'Patient admitted at Civil Hospital Ahmedabad requires immediate assistance for dialysis medicines and O+ blood donor support.',
        'categoryId': 'cat_healthcare',
        'categoryName': 'Healthcare & Medicines',
        'priority': 'emergency',
        'totalQuantity': 2,
        'remainingQuantity': 1,
        'quantityUnit': 'units',
        'city': 'Ahmedabad',
        'areaName': 'Civil Hospital, Asarwa',
        'latitude': 23.0528,
        'longitude': 72.5936,
        'durationText': 'Immediate / 24 Hours',
        'expiresAt': '2026-10-30',
        'status': 'open',
        'mediaUrls': jsonEncode([
          'https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?w=800',
        ]),
        'contactInstructions': 'Contact hospital reception desk room 402',
        'isClosedEarly': 0,
        'createdAt': '2026-10-27 10:00 AM',
      },
      {
        'id': 'post_need_2',
        'userId': 'user_meera',
        'userName': 'Meera Shah',
        'userAvatar':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
        'userIsVerified': 1,
        'type': 'need',
        'title': 'School Uniform & Books for Class 8 Student',
        'description': 'Student in Satellite area needs standard 8 NCERT Gujarat textbook set and notebook stationery.',
        'categoryId': 'cat_education',
        'categoryName': 'Education & Supplies',
        'priority': 'high',
        'totalQuantity': 3,
        'remainingQuantity': 3,
        'quantityUnit': 'kits',
        'city': 'Ahmedabad',
        'areaName': 'Satellite, Ahmedabad',
        'latitude': 23.0300,
        'longitude': 72.5176,
        'durationText': 'Within 3 days',
        'expiresAt': '2026-11-05',
        'status': 'open',
        'mediaUrls': jsonEncode([
          'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=800',
        ]),
        'contactInstructions': 'Drop at Community Center near Shivranjani',
        'isClosedEarly': 0,
        'createdAt': '2026-10-26 03:30 PM',
      },
      {
        'id': 'post_offer_1',
        'userId': 'user_current',
        'userName': 'Aarav Patel',
        'userAvatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
        'userIsVerified': 1,
        'type': 'offer',
        'title': 'Offering 20 Fresh Cooked Food Packets',
        'description': 'Hygienically prepared khichdi and roti packets available for distribution to night shelters or families in need.',
        'categoryId': 'cat_food',
        'categoryName': 'Food & Groceries',
        'priority': 'normal',
        'totalQuantity': 20,
        'remainingQuantity': 15,
        'quantityUnit': 'meals',
        'city': 'Ahmedabad',
        'areaName': 'Navrangpura, Ahmedabad',
        'latitude': 23.0368,
        'longitude': 72.5615,
        'durationText': 'Available till 8 PM today',
        'expiresAt': '2026-10-27 20:00',
        'status': 'open',
        'mediaUrls': jsonEncode([
          'https://images.unsplash.com/photo-1593113598332-cd288d649433?w=800',
        ]),
        'contactInstructions': 'Pickup near Commerce Six Roads metro station',
        'isClosedEarly': 0,
        'createdAt': '2026-10-27 12:00 PM',
      },
      {
        'id': 'post_surat_1',
        'userId': 'user_surat_helper',
        'userName': 'Rajesh Varma',
        'userAvatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
        'userIsVerified': 1,
        'type': 'need',
        'title': 'Winter Blankets Needed for Textile Workers',
        'description': 'Night shift textile workers near Ring Road Surat require warm blankets and sweaters.',
        'categoryId': 'cat_clothing',
        'categoryName': 'Clothing & Wear',
        'priority': 'high',
        'totalQuantity': 10,
        'remainingQuantity': 8,
        'quantityUnit': 'pairs',
        'city': 'Surat',
        'areaName': 'Ring Road, Surat',
        'latitude': 21.1702,
        'longitude': 72.8311,
        'durationText': 'This week',
        'expiresAt': '2026-11-10',
        'status': 'open',
        'mediaUrls': jsonEncode([
          'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=800',
        ]),
        'contactInstructions':
            'Contact community coordinator near Textile Market',
        'isClosedEarly': 0,
        'createdAt': '2026-10-25 11:00 AM',
      },
    ];

    for (var p in posts) {
      await db.insert('posts', p, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // 5. Initial Notifications
    final notifications = [
      {
        'id': 'notif_1',
        'userId': 'user_current',
        'title': 'Welcome to SaathiApp!',
        'body': 'Your account is active. You can request or offer help in your city.',
        'type': 'verification',
        'relatedEntityId': '',
        'timestamp': '2026-10-27 09:00 AM',
        'isRead': 1,
      },
      {
        'id': 'notif_2',
        'userId': 'user_current',
        'title': 'Emergency Alert in Ahmedabad',
        'body': 'Urgent O+ blood requirement at Civil Hospital.',
        'type': 'emergency',
        'relatedEntityId': 'post_emergency_1',
        'timestamp': '2026-10-27 10:05 AM',
        'isRead': 0,
      },
    ];

    for (var n in notifications) {
      await db.insert(
        'notifications',
        n,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    // 6. Monthly Usage Initial Record
    await db.insert('monthly_usages', {
      'userId': 'user_current',
      'yearMonth': '2026-10',
      'count': 3,
      'limitVal': 15,
      'exceptionRequested': 0,
      'exceptionReason': '',
      'exceptionStatus': 'none',
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    // 7. Preferences
    await db.insert('preferences', {
      'userId': 'user_current',
      'emergencyAlerts': 1,
      'categoryUpdates': 1,
      'reservationAlerts': 1,
      'chatMessages': 1,
      'communityBanners': 1,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
