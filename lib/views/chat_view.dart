import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../viewmodels/vehicle_controller.dart';

class ChatView extends StatefulWidget {
  final String userName;
  final String userInitials;
  final Color avatarColor;

  const ChatView({
    super.key,
    required this.userName,
    required this.userInitials,
    required this.avatarColor,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    // Initialize with mock messages
    _messages.addAll(_getMockMessages(widget.userName));
    // Scroll to bottom after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(
        text: _messageController.text.trim(),
        isSent: true,
        time: DateTime.now(),
      ));
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate a reply after a delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(_ChatMessage(
            text: _getMockReply(widget.userName),
            isSent: false,
            time: DateTime.now(),
          ));
        });
        _scrollToBottom();
      }
    });
  }

  List<_ChatMessage> _getMockMessages(String userName) {
    return [
      _ChatMessage(
        text: 'Hi! Is the car still available?',
        isSent: false,
        time: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      _ChatMessage(
        text: 'Yes, it\'s still available. Would you like to schedule a viewing?',
        isSent: true,
        time: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      ),
      _ChatMessage(
        text: 'That would be great! When are you available?',
        isSent: false,
        time: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      ),
      _ChatMessage(
        text: 'I\'m available this weekend. Saturday or Sunday works for me.',
        isSent: true,
        time: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      _ChatMessage(
        text: 'Perfect! Let\'s do Saturday at 2 PM. What\'s the address?',
        isSent: false,
        time: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];
  }

  String _getMockReply(String userName) {
    final replies = [
      'Sounds good! I\'ll send you the address shortly.',
      'Great! Looking forward to meeting you.',
      'Perfect timing! See you then.',
      'I\'ll confirm the details and get back to you.',
    ];
    return replies[_messages.length % replies.length];
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VehicleController>();

    return Obx(() {
      final isDark = controller.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
            onPressed: () => Get.back(),
          ),
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.avatarColor,
                ),
                child: Center(
                  child: Text(
                    widget.userInitials,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.mutedDark
                            : AppColors.mutedLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          children: [
            // Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _MessageBubble(
                    message: message,
                    isDark: isDark,
                    avatarColor: widget.avatarColor,
                    userInitials: widget.userInitials,
                  );
                },
              ),
            ),
            // Input Area
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                ),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                            color: isDark
                                ? AppColors.mutedDark
                                : AppColors.mutedLight,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? AppColors.backgroundDark
                              : AppColors.gray200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white : Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: isDark ? Colors.black : Colors.white,
                        ),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;
  final bool isDark;
  final Color avatarColor;
  final String userInitials;

  const _MessageBubble({
    required this.message,
    required this.isDark,
    required this.avatarColor,
    required this.userInitials,
  });

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (message.isSent) {
      // Sent message (right aligned)
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? Colors.white : Colors.black,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message.text,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.black : Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatTime(message.time),
                style: TextStyle(
                  fontSize: 10,
                  color: isDark
                      ? Colors.black.withOpacity(0.6)
                      : Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Received message (left aligned with avatar)
      return Align(
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: avatarColor,
              ),
              child: Center(
                child: Text(
                  userInitials,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.gray200,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.textDark : AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.time),
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark
                          ? AppColors.mutedDark
                          : AppColors.mutedLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}

class _ChatMessage {
  final String text;
  final bool isSent;
  final DateTime time;

  _ChatMessage({
    required this.text,
    required this.isSent,
    required this.time,
  });
}

