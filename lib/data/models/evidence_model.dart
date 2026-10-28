class EvidenceModel {
  final String id;
  final String reservationId;
  final String postId;
  final String uploadedByUserId;
  final String uploadedByUserName;
  final String userRole; // 'provider' or 'recipient'
  final String photoUrl;
  final String description;
  final String timestamp;

  EvidenceModel({
    required this.id,
    required this.reservationId,
    required this.postId,
    required this.uploadedByUserId,
    required this.uploadedByUserName,
    required this.userRole,
    required this.photoUrl,
    this.description = '',
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reservationId': reservationId,
      'postId': postId,
      'uploadedByUserId': uploadedByUserId,
      'uploadedByUserName': uploadedByUserName,
      'userRole': userRole,
      'photoUrl': photoUrl,
      'description': description,
      'timestamp': timestamp,
    };
  }

  factory EvidenceModel.fromMap(Map<String, dynamic> map) {
    return EvidenceModel(
      id: map['id'] ?? '',
      reservationId: map['reservationId'] ?? '',
      postId: map['postId'] ?? '',
      uploadedByUserId: map['uploadedByUserId'] ?? '',
      uploadedByUserName: map['uploadedByUserName'] ?? '',
      userRole: map['userRole'] ?? 'provider',
      photoUrl: map['photoUrl'] ?? '',
      description: map['description'] ?? '',
      timestamp: map['timestamp'] ?? '',
    );
  }
}
