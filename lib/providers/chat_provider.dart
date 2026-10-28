import 'package:flutter/material.dart';

import '../data/models/chat_message_model.dart';
import '../data/repositories/chat_repository.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository _chatRepository = ChatRepository();

  List<ChatMessageModel> _messages = [];
  bool _isLoading = false;

  List<ChatMessageModel> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> fetchMessages(String conversationId) async {
    _isLoading = true;
    notifyListeners();

    _messages = await _chatRepository.getMessagesForConversation(
      conversationId,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    required String receiverId,
    required String text,
    bool containsContactDetails = false,
  }) async {
    final msg = await _chatRepository.sendMessage(
      conversationId: conversationId,
      senderId: senderId,
      senderName: senderName,
      receiverId: receiverId,
      text: text,
      containsContactDetails: containsContactDetails,
    );

    _messages.add(msg);
    notifyListeners();
  }
}
