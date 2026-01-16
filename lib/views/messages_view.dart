import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../viewmodels/vehicle_controller.dart';
import '../widgets/bottom_nav_bar.dart';
import 'chat_view.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

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
          title: const Text(
            'Messages',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.backgroundDark
                      : AppColors.backgroundLight,
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                    ),
                  ),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search conversations...',
                    hintStyle: TextStyle(
                      color: isDark
                          ? AppColors.mutedDark
                          : AppColors.mutedLight,
                    ),
                    filled: true,
                    fillColor: isDark ? AppColors.cardDark : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? Colors.white : Colors.black,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDark
                          ? AppColors.mutedDark
                          : AppColors.mutedLight,
                    ),
                  ),
                ),
              ),
              // Conversations List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _mockConversations.length,
                  itemBuilder: (context, index) {
                    final conversation = _mockConversations[index];
                    return _ConversationItem(
                      conversation: conversation,
                      isDark: isDark,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavBar(
          currentIndex: 3,
          onTap: _handleNavTap,
        ),
      );
    });
  }

  static void _handleNavTap(int index) {
    switch (index) {
      case 0:
        Get.offNamed('/home');
        break;
      case 1:
        Get.snackbar(
          'Favorites',
          'Favorites page coming soon',
          snackPosition: SnackPosition.TOP,
        );
        break;
      case 2:
        Get.snackbar(
          'Sell',
          'Sell your car page coming soon',
          snackPosition: SnackPosition.TOP,
        );
        break;
      case 3:
        // Already on messages
        break;
      case 4:
        Get.toNamed('/profile');
        break;
    }
  }
}

class _ConversationItem extends StatelessWidget {
  final _MockConversation conversation;
  final bool isDark;

  const _ConversationItem({
    required this.conversation,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => ChatView(
          userName: conversation.name,
          userInitials: conversation.initials,
          avatarColor: conversation.avatarColor,
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: conversation.avatarColor,
              ),
              child: Center(
                child: Text(
                  conversation.initials,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Message Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          conversation.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        conversation.time,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.mutedDark
                              : AppColors.mutedLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? AppColors.mutedDark
                                : AppColors.mutedLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (conversation.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            conversation.unreadCount.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MockConversation {
  final String name;
  final String initials;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final Color avatarColor;

  _MockConversation({
    required this.name,
    required this.initials,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.avatarColor,
  });
}

final List<_MockConversation> _mockConversations = [
  _MockConversation(
    name: 'Sarah Johnson',
    initials: 'SJ',
    lastMessage: 'Hi! Is the car still available?',
    time: '2m ago',
    unreadCount: 2,
    avatarColor: Colors.blue,
  ),
  _MockConversation(
    name: 'Michael Chen',
    initials: 'MC',
    lastMessage: 'Can I schedule a test drive?',
    time: '15m ago',
    unreadCount: 0,
    avatarColor: Colors.green,
  ),
  _MockConversation(
    name: 'Emma Williams',
    initials: 'EW',
    lastMessage: 'What\'s the mileage on this vehicle?',
    time: '1h ago',
    unreadCount: 1,
    avatarColor: Colors.orange,
  ),
  _MockConversation(
    name: 'David Brown',
    initials: 'DB',
    lastMessage: 'Thanks for the information!',
    time: '3h ago',
    unreadCount: 0,
    avatarColor: Colors.purple,
  ),
  _MockConversation(
    name: 'Lisa Anderson',
    initials: 'LA',
    lastMessage: 'I\'m interested in viewing the car this weekend.',
    time: '5h ago',
    unreadCount: 0,
    avatarColor: Colors.teal,
  ),
  _MockConversation(
    name: 'James Wilson',
    initials: 'JW',
    lastMessage: 'What payment methods do you accept?',
    time: '1d ago',
    unreadCount: 0,
    avatarColor: Colors.red,
  ),
  _MockConversation(
    name: 'Maria Garcia',
    initials: 'MG',
    lastMessage: 'Is financing available?',
    time: '2d ago',
    unreadCount: 0,
    avatarColor: Colors.indigo,
  ),
  _MockConversation(
    name: 'Robert Taylor',
    initials: 'RT',
    lastMessage: 'Can you send more photos?',
    time: '3d ago',
    unreadCount: 0,
    avatarColor: Colors.pink,
  ),
];

