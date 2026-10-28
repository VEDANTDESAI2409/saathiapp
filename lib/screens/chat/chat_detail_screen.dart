import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';

class ChatDetailScreen extends StatefulWidget {
  final String conversationId;
  final String partnerName;
  final String partnerId;

  const ChatDetailScreen({
    super.key,
    required this.conversationId,
    required this.partnerName,
    required this.partnerId,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _msgController = TextEditingController();
  bool _sharedContact = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(
        context,
        listen: false,
      ).fetchMessages(widget.conversationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(title: Text(widget.partnerName)),
      body: Column(
        children: [
          // Safe Contact Sharing Warning Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppColors.softMint,
            child: Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  color: AppColors.trustTeal,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'To protect privacy, do not share phone/address until help arrangement is confirmed.',
                    style: TextStyle(fontSize: 11, color: AppColors.deepForest),
                  ),
                ),
                if (!_sharedContact)
                  TextButton(
                    onPressed: () {
                      setState(() => _sharedContact = true);
                      if (user != null) {
                        chatProvider.sendMessage(
                          conversationId: widget.conversationId,
                          senderId: user.id,
                          senderName: user.name,
                          receiverId: widget.partnerId,
                          text: 'Phone Number Shared: ${user.phone}',
                          containsContactDetails: true,
                        );
                      }
                    },
                    child: const Text(
                      'Share Phone',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: chatProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : chatProvider.messages.isEmpty
                ? const Center(
                    child: Text('Start conversation to coordinate help.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (context, i) {
                      final msg = chatProvider.messages[i];
                      final isMe = msg.senderId == user?.id;

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: isMe ? AppColors.trustTeal : AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: isMe
                                ? null
                                : Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg.text,
                                style: TextStyle(
                                  color: isMe
                                      ? AppColors.white
                                      : AppColors.deepForest,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                msg.timestamp,
                                style: TextStyle(
                                  color: isMe
                                      ? AppColors.softMint
                                      : AppColors.textMuted,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Message Input Field
          Container(
            padding: const EdgeInsets.all(12),
            color: AppColors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send_rounded,
                    color: AppColors.trustTeal,
                  ),
                  onPressed: () {
                    final txt = _msgController.text.trim();
                    if (txt.isNotEmpty && user != null) {
                      chatProvider.sendMessage(
                        conversationId: widget.conversationId,
                        senderId: user.id,
                        senderName: user.name,
                        receiverId: widget.partnerId,
                        text: txt,
                      );
                      _msgController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
