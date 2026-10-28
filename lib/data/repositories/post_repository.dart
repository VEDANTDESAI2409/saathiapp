import 'package:sqflite/sqflite.dart';

import '../database/db_helper.dart';
import '../models/post_model.dart';
import '../models/monthly_usage_model.dart';

class PostRepository {
  Future<List<PostModel>> getPosts({
    String? city,
    String? categoryId,
    String? type,
    String? priority,
    String? searchQuery,
    String? status,
    bool includeCompleted = false,
  }) async {
    final db = await DBHelper.database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    // Exclude completed requests from active feeds by default
    if (!includeCompleted) {
      whereClause += "status != 'completed' AND status != 'closed'";
    }

    if (city != null && city.isNotEmpty && city != 'All Cities') {
      whereClause += '${whereClause.isEmpty ? '' : ' AND '}city = ?';
      whereArgs.add(city);
    }

    if (categoryId != null && categoryId.isNotEmpty && categoryId != 'all') {
      whereClause += '${whereClause.isEmpty ? '' : ' AND '}categoryId = ?';
      whereArgs.add(categoryId);
    }

    if (type != null && type.isNotEmpty && type != 'all') {
      whereClause += '${whereClause.isEmpty ? '' : ' AND '}type = ?';
      whereArgs.add(type);
    }

    if (priority != null && priority.isNotEmpty && priority != 'all') {
      whereClause += '${whereClause.isEmpty ? '' : ' AND '}priority = ?';
      whereArgs.add(priority);
    }

    if (status != null && status.isNotEmpty && status != 'all') {
      whereClause += '${whereClause.isEmpty ? '' : ' AND '}status = ?';
      whereArgs.add(status);
    }

    final maps = await db.query(
      'posts',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: "CASE priority WHEN 'emergency' THEN 1 WHEN 'high' THEN 2 ELSE 3 END, createdAt DESC",
    );

    List<PostModel> posts = maps.map((m) => PostModel.fromMap(m)).toList();

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase().trim();
      posts = posts
          .where(
            (p) =>
                p.title.toLowerCase().contains(q) ||
                p.description.toLowerCase().contains(q) ||
                p.areaName.toLowerCase().contains(q) ||
                p.categoryName.toLowerCase().contains(q),
          )
          .toList();
    }

    return posts;
  }

  Future<PostModel?> getPostById(String id) async {
    final db = await DBHelper.database;
    final maps = await db.query('posts', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return PostModel.fromMap(maps.first);
    }
    return null;
  }

  Future<MonthlyUsageModel> getMonthlyUsage(String userId) async {
    final db = await DBHelper.database;
    final ym =
        "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}";
    final maps = await db.query(
      'monthly_usages',
      where: 'userId = ? AND yearMonth = ?',
      whereArgs: [userId, ym],
    );

    if (maps.isNotEmpty) {
      return MonthlyUsageModel.fromMap(maps.first);
    }

    final newUsage = MonthlyUsageModel(
      userId: userId,
      yearMonth: ym,
      count: 0,
      limit: 15,
    );
    await db.insert('monthly_usages', newUsage.toMap());
    return newUsage;
  }

  Future<void> incrementMonthlyUsage(String userId) async {
    final db = await DBHelper.database;
    final ym =
        "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}";
    final usage = await getMonthlyUsage(userId);

    await db.update(
      'monthly_usages',
      {'count': usage.count + 1},
      where: 'userId = ? AND yearMonth = ?',
      whereArgs: [userId, ym],
    );
  }

  Future<PostModel> createPost(PostModel post) async {
    final db = await DBHelper.database;
    await db.insert(
      'posts',
      post.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Increment monthly help instance count
    await incrementMonthlyUsage(post.userId);

    return post;
  }

  Future<void> closePostEarly(String postId) async {
    final db = await DBHelper.database;
    await db.update(
      'posts',
      {'status': 'closed', 'isClosedEarly': 1},
      where: 'id = ?',
      whereArgs: [postId],
    );
  }

  Future<void> reopenPost(String postId) async {
    final db = await DBHelper.database;
    final maps = await db.query('posts', where: 'id = ?', whereArgs: [postId]);
    if (maps.isNotEmpty) {
      final post = PostModel.fromMap(maps.first);
      if (post.status == 'completed') {
        throw Exception('Completed posts cannot be reopened.');
      }
      await db.update(
        'posts',
        {'status': 'open', 'isClosedEarly': 0},
        where: 'id = ?',
        whereArgs: [postId],
      );
    }
  }

  Future<void> updatePostStatus(String postId, String newStatus) async {
    final db = await DBHelper.database;
    await db.update(
      'posts',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [postId],
    );
  }
}
