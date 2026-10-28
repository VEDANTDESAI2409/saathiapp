import '../database/db_helper.dart';
import '../models/reservation_model.dart';
import '../models/post_model.dart';
import '../models/evidence_model.dart';

class ReservationRepository {
  Future<List<ReservationModel>> getReservationsForUser(String userId) async {
    final db = await DBHelper.database;
    final maps = await db.query(
      'reservations',
      where: 'reservedById = ? OR postOwnerId = ?',
      whereArgs: [userId, userId],
      orderBy: 'createdAt DESC',
    );
    return maps.map((m) => ReservationModel.fromMap(m)).toList();
  }

  Future<ReservationModel> createReservation({
    required PostModel post,
    required String reservedById,
    required String reservedByName,
    required String userPreferredCity,
    required int reservedQuantity,
    String note = '',
  }) async {
    final db = await DBHelper.database;

    // Requirement 1 Enforcement: City matching rule
    if (userPreferredCity.trim().toLowerCase() !=
        post.city.trim().toLowerCase()) {
      throw Exception(
        'You can only fulfill/reserve help requests in your registered preferred city ($userPreferredCity).',
      );
    }

    // Check if remaining quantity is sufficient
    if (post.remainingQuantity < reservedQuantity) {
      throw Exception(
        'Requested quantity exceeds available remaining quantity.',
      );
    }

    final newReservation = ReservationModel(
      id: 'res_${DateTime.now().millisecondsSinceEpoch}',
      postId: post.id,
      postTitle: post.title,
      postType: post.type,
      categoryName: post.categoryName,
      postOwnerId: post.userId,
      postOwnerName: post.userName,
      reservedById: reservedById,
      reservedByName: reservedByName,
      reservedQuantity: reservedQuantity,
      status: 'confirmed',
      note: note,
      createdAt: DateTime.now().toIso8601String().split('.').first,
    );

    await db.insert('reservations', newReservation.toMap());

    // Update remaining quantity on post
    final newRemaining = post.remainingQuantity - reservedQuantity;
    final newStatus = newRemaining == 0
        ? 'help_arranged'
        : 'assistance_offered';

    await db.update(
      'posts',
      {'remainingQuantity': newRemaining, 'status': newStatus},
      where: 'id = ?',
      whereArgs: [post.id],
    );

    // Add notification to post owner
    await db.insert('notifications', {
      'id': 'notif_${DateTime.now().millisecondsSinceEpoch}',
      'userId': post.userId,
      'title': 'New Assistance Reservation!',
      'body':
          '$reservedByName reserved $reservedQuantity item(s) for "${post.title}".',
      'type': 'reservation',
      'relatedEntityId': post.id,
      'timestamp': DateTime.now().toIso8601String().split('.').first,
      'isRead': 0,
    });

    return newReservation;
  }

  Future<void> cancelReservation(ReservationModel reservation) async {
    final db = await DBHelper.database;
    await db.update(
      'reservations',
      {'status': 'cancelled'},
      where: 'id = ?',
      whereArgs: [reservation.id],
    );

    // Restore post quantity
    final postMaps = await db.query(
      'posts',
      where: 'id = ?',
      whereArgs: [reservation.postId],
    );
    if (postMaps.isNotEmpty) {
      final post = PostModel.fromMap(postMaps.first);
      final restoredQty = post.remainingQuantity + reservation.reservedQuantity;
      await db.update(
        'posts',
        {
          'remainingQuantity': restoredQty,
          'status': restoredQty > 0 ? 'open' : post.status,
        },
        where: 'id = ?',
        whereArgs: [post.id],
      );
    }
  }

  Future<void> completeReservation({
    required ReservationModel reservation,
    required String currentUserId,
    required String currentUserName,
    required String photoUrl,
    String notes = '',
  }) async {
    // Requirement 12 Enforcement: Mandatory Photo Evidence
    if (photoUrl.trim().isEmpty) {
      throw Exception(
        'Photo evidence is required to complete this assistance.',
      );
    }

    final db = await DBHelper.database;

    // 1. Save evidence
    final evidence = EvidenceModel(
      id: 'ev_${DateTime.now().millisecondsSinceEpoch}',
      reservationId: reservation.id,
      postId: reservation.postId,
      uploadedByUserId: currentUserId,
      uploadedByUserName: currentUserName,
      userRole: currentUserId == reservation.reservedById
          ? 'provider'
          : 'recipient',
      photoUrl: photoUrl,
      description: notes,
      timestamp: DateTime.now().toIso8601String().split('.').first,
    );

    await db.insert('evidence', evidence.toMap());

    // 2. Mark reservation as completed
    await db.update(
      'reservations',
      {'status': 'completed'},
      where: 'id = ?',
      whereArgs: [reservation.id],
    );

    // 3. Mark post as completed (which removes it from Home & Explore active feeds)
    await db.update(
      'posts',
      {'status': 'completed'},
      where: 'id = ?',
      whereArgs: [reservation.postId],
    );

    // 4. Update user score & helps count
    final userMaps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [reservation.reservedById],
    );
    if (userMaps.isNotEmpty) {
      final score = (userMaps.first['contributionScore'] as int? ?? 0) + 20;
      final done = (userMaps.first['helpsDoneCount'] as int? ?? 0) + 1;
      await db.update(
        'users',
        {'contributionScore': score, 'helpsDoneCount': done},
        where: 'id = ?',
        whereArgs: [reservation.reservedById],
      );
    }
  }

  Future<List<EvidenceModel>> getEvidenceForReservation(
    String reservationId,
  ) async {
    final db = await DBHelper.database;
    final maps = await db.query(
      'evidence',
      where: 'reservationId = ?',
      whereArgs: [reservationId],
    );
    return maps.map((m) => EvidenceModel.fromMap(m)).toList();
  }
}
