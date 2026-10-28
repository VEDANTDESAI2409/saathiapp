import '../database/db_helper.dart';
import '../models/chat_message_model.dart';

class ChatRepository {
  Future<List<ChatMessageModel>> getMessagesForConversation(
    String conversationId,
  ) async {
    final db = await DBHelper.database;
    final maps = await db.query(
      'chat_messages',
      where: 'conversationId = ?',
      whereArgs: [conversationId],
      orderBy: 'timestamp ASC',
    );
    return maps.map((m) => ChatMessageModel.fromMap(m)).toList();
  }

  Future<ChatMessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    required String receiverId,
    required String text,
    bool containsContactDetails = false,
  }) async {
    final db = await DBHelper.database;
    final msg = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: senderId,
      senderName: senderName,
      receiverId: receiverId,
      text: text,
      timestamp: DateTime.now().toIso8601String().split('.').first,
      containsContactDetails: containsContactDetails,
    );

    await db.insert('chat_messages', msg.toMap());
    return msg;
  }
}
