import 'package:flutter_test/flutter_test.dart';
import 'package:saathiapp/data/models/post_model.dart';
import 'package:saathiapp/data/models/user_model.dart';
import 'package:saathiapp/data/models/monthly_usage_model.dart';
import 'package:saathiapp/core/config/app_config.dart';

void main() {
  group('SaathiApp Model & Logic Tests', () {
    test('PostModel serialization & copyWith test', () {
      final post = PostModel(
        id: 'post_123',
        userId: 'user_1',
        userName: 'Aarav Patel',
        type: 'need',
        title: 'Food Packets Need',
        description: 'Cooked meals needed in Paldi',
        categoryId: 'cat_food',
        categoryName: 'Food & Groceries',
        priority: 'emergency',
        totalQuantity: 10,
        remainingQuantity: 5,
        city: 'Ahmedabad',
        areaName: 'Paldi',
        createdAt: '2026-10-27',
      );

      expect(post.isEmergency, true);
      expect(post.isNeed, true);
      expect(post.remainingQuantity, 5);

      final map = post.toMap();
      final restored = PostModel.fromMap(map);

      expect(restored.id, 'post_123');
      expect(restored.city, 'Ahmedabad');
      expect(restored.priority, 'emergency');
    });

    test('UserModel serialization test', () {
      final user = UserModel(
        id: 'user_aarav',
        name: 'Aarav Patel',
        phone: '+91 9876543210',
        email: 'aarav@saathiapp.org',
        registeredCity: 'Ahmedabad',
        isVerified: true,
        verificationStatus: 'approved',
        contributionScore: 240,
        createdAt: '2026-01-01',
      );

      expect(user.isVerified, true);
      expect(user.contributionScore, 240);

      final map = user.toMap();
      final restored = UserModel.fromMap(map);
      expect(restored.name, 'Aarav Patel');
      expect(restored.registeredCity, 'Ahmedabad');
    });

    test('MonthlyUsageModel limit check test', () {
      final usageUnder = MonthlyUsageModel(
        userId: 'u1',
        yearMonth: '2026-10',
        count: 5,
        limit: 15,
      );
      expect(usageUnder.isLimitReached, false);

      final usageReached = MonthlyUsageModel(
        userId: 'u1',
        yearMonth: '2026-10',
        count: 15,
        limit: 15,
      );
      expect(usageReached.isLimitReached, true);
    });

    test('AppConfig helpline check test', () {
      expect(AppConfig.isHelplineConfigured(), true);
      expect(AppConfig.monthlyHelpLimit, 15);
    });
  });
}
