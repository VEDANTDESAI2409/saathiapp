class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String
  type; // 'reservation', 'status_change', 'chat', 'verification', 'emergency'
  final String relatedEntityId;
  final String timestamp;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.relatedEntityId = '',
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'type': type,
      'relatedEntityId': relatedEntityId,
      'timestamp': timestamp,
      'isRead': isRead ? 1 : 0,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      type: map['type'] ?? 'general',
      relatedEntityId: map['relatedEntityId'] ?? '',
      timestamp: map['timestamp'] ?? '',
      isRead: map['isRead'] == 1 || map['isRead'] == true,
    );
  }
}
