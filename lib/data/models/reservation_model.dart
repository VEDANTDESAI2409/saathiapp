class ReservationModel {
  final String id;
  final String postId;
  final String postTitle;
  final String postType; // 'need' or 'offer'
  final String categoryName;
  final String postOwnerId;
  final String postOwnerName;
  final String reservedById;
  final String reservedByName;
  final int reservedQuantity;
  final String
  status; // 'pending', 'confirmed', 'arranged', 'completed', 'cancelled'
  final String note;
  final String createdAt;

  ReservationModel({
    required this.id,
    required this.postId,
    required this.postTitle,
    required this.postType,
    required this.categoryName,
    required this.postOwnerId,
    required this.postOwnerName,
    required this.reservedById,
    required this.reservedByName,
    required this.reservedQuantity,
    this.status = 'confirmed',
    this.note = '',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'postTitle': postTitle,
      'postType': postType,
      'categoryName': categoryName,
      'postOwnerId': postOwnerId,
      'postOwnerName': postOwnerName,
      'reservedById': reservedById,
      'reservedByName': reservedByName,
      'reservedQuantity': reservedQuantity,
      'status': status,
      'note': note,
      'createdAt': createdAt,
    };
  }

  factory ReservationModel.fromMap(Map<String, dynamic> map) {
    return ReservationModel(
      id: map['id'] ?? '',
      postId: map['postId'] ?? '',
      postTitle: map['postTitle'] ?? '',
      postType: map['postType'] ?? 'need',
      categoryName: map['categoryName'] ?? 'General',
      postOwnerId: map['postOwnerId'] ?? '',
      postOwnerName: map['postOwnerName'] ?? '',
      reservedById: map['reservedById'] ?? '',
      reservedByName: map['reservedByName'] ?? '',
      reservedQuantity: map['reservedQuantity'] ?? 1,
      status: map['status'] ?? 'confirmed',
      note: map['note'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }

  ReservationModel copyWith({
    String? id,
    String? postId,
    String? postTitle,
    String? postType,
    String? categoryName,
    String? postOwnerId,
    String? postOwnerName,
    String? reservedById,
    String? reservedByName,
    int? reservedQuantity,
    String? status,
    String? note,
    String? createdAt,
  }) {
    return ReservationModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      postTitle: postTitle ?? this.postTitle,
      postType: postType ?? this.postType,
      categoryName: categoryName ?? this.categoryName,
      postOwnerId: postOwnerId ?? this.postOwnerId,
      postOwnerName: postOwnerName ?? this.postOwnerName,
      reservedById: reservedById ?? this.reservedById,
      reservedByName: reservedByName ?? this.reservedByName,
      reservedQuantity: reservedQuantity ?? this.reservedQuantity,
      status: status ?? this.status,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
