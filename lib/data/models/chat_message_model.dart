class ChatMessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String text;
  final String timestamp;
  final bool isRead;
  final bool containsContactDetails;

  ChatMessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
    this.containsContactDetails = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp,
      'isRead': isRead ? 1 : 0,
      'containsContactDetails': containsContactDetails ? 1 : 0,
    };
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      id: map['id'] ?? '',
      conversationId: map['conversationId'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] ?? '',
      isRead: map['isRead'] == 1 || map['isRead'] == true,
      containsContactDetails:
          map['containsContactDetails'] == 1 ||
          map['containsContactDetails'] == true,
    );
  }
}
