import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/chat_header_widget.dart';
import './widgets/chat_input_widget.dart';
import './widgets/message_bubble_widget.dart';
import './widgets/message_options_widget.dart';
import './widgets/typing_indicator_widget.dart';

class ChatMessagingScreen extends StatefulWidget {
  const ChatMessagingScreen({Key? key}) : super(key: key);

  @override
  State<ChatMessagingScreen> createState() => _ChatMessagingScreenState();
}

class _ChatMessagingScreenState extends State<ChatMessagingScreen> {
  final ScrollController _scrollController = ScrollController();
  final String _currentUserId = "user_1";
  bool _isTyping = false;
  bool _isLoading = false;

  // Mock match profile data
  final Map<String, dynamic> _matchProfile = {
    "id": "user_2",
    "name": "Emma Rodriguez",
    "profileImage":
        "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
    "isOnline": true,
    "lastSeen": DateTime.now().subtract(const Duration(minutes: 5)),
  };

  // Mock messages data
  List<Map<String, dynamic>> _messages = [
    {
      "id": "msg_1",
      "senderId": "user_2",
      "senderAvatar":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "content": "Hey! How was your day?",
      "type": "text",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "isDelivered": true,
      "isRead": true,
    },
    {
      "id": "msg_2",
      "senderId": "user_1",
      "senderAvatar":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
      "content": "It was great! Just finished work. How about you?",
      "type": "text",
      "timestamp":
          DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      "isDelivered": true,
      "isRead": true,
    },
    {
      "id": "msg_3",
      "senderId": "user_2",
      "senderAvatar":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "content": "Same here! Want to grab coffee tomorrow?",
      "type": "text",
      "timestamp":
          DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      "isDelivered": true,
      "isRead": true,
    },
    {
      "id": "msg_4",
      "senderId": "user_1",
      "senderAvatar":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
      "imageUrl":
          "https://images.pexels.com/photos/302899/pexels-photo-302899.jpeg?auto=compress&cs=tinysrgb&w=800",
      "caption": "Found this amazing coffee shop! ☕",
      "type": "image",
      "timestamp":
          DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
      "isDelivered": true,
      "isRead": true,
    },
    {
      "id": "msg_5",
      "senderId": "user_2",
      "senderAvatar":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "content": "Wow, that looks perfect! What time works for you?",
      "type": "text",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 45)),
      "isDelivered": true,
      "isRead": true,
    },
    {
      "id": "msg_6",
      "senderId": "user_1",
      "senderAvatar":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
      "content": "How about 10 AM? I can pick you up if you'd like 😊",
      "type": "text",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 30)),
      "isDelivered": true,
      "isRead": false,
    },
    {
      "id": "msg_7",
      "senderId": "user_1",
      "senderAvatar":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
      "content": "Let me know what you think!",
      "type": "text",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 15)),
      "isDelivered": false,
      "isRead": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animated = true}) {
    if (_scrollController.hasClients) {
      if (animated) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    }
  }

  void _sendMessage(String content) {
    final newMessage = {
      "id": "msg_${DateTime.now().millisecondsSinceEpoch}",
      "senderId": _currentUserId,
      "senderAvatar":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
      "content": content,
      "type": "text",
      "timestamp": DateTime.now(),
      "isDelivered": false,
      "isRead": false,
    };

    setState(() {
      _messages.add(newMessage);
    });

    _scrollToBottom();

    // Simulate message delivery
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          final index =
              _messages.indexWhere((msg) => msg["id"] == newMessage["id"]);
          if (index != -1) {
            _messages[index]["isDelivered"] = true;
          }
        });
      }
    });

    // Simulate typing response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = true;
        });
      }
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
        });
        _simulateResponse();
      }
    });
  }

  void _sendImage(String imagePath, String? caption) {
    final newMessage = {
      "id": "msg_${DateTime.now().millisecondsSinceEpoch}",
      "senderId": _currentUserId,
      "senderAvatar":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
      "imageUrl": imagePath,
      "caption": caption ?? "",
      "type": "image",
      "timestamp": DateTime.now(),
      "isDelivered": false,
      "isRead": false,
    };

    setState(() {
      _messages.add(newMessage);
    });

    _scrollToBottom();

    // Simulate upload and delivery
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          final index =
              _messages.indexWhere((msg) => msg["id"] == newMessage["id"]);
          if (index != -1) {
            _messages[index]["isDelivered"] = true;
          }
        });
      }
    });
  }

  void _simulateResponse() {
    final responses = [
      "That sounds great!",
      "I'd love to! 😊",
      "Perfect timing!",
      "Can't wait!",
      "See you then! ❤️",
    ];

    final randomResponse =
        responses[DateTime.now().millisecond % responses.length];

    final responseMessage = {
      "id": "msg_${DateTime.now().millisecondsSinceEpoch}",
      "senderId": _matchProfile["id"],
      "senderAvatar": _matchProfile["profileImage"],
      "content": randomResponse,
      "type": "text",
      "timestamp": DateTime.now(),
      "isDelivered": true,
      "isRead": false,
    };

    setState(() {
      _messages.add(responseMessage);
    });

    _scrollToBottom();
  }

  void _onTyping() {
    // Handle typing indicator for current user
  }

  void _deleteMessage(String messageId) {
    setState(() {
      _messages.removeWhere((msg) => msg["id"] == messageId);
    });

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Message deleted'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _reportMessage(String messageId) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
            'Message reported. Thank you for keeping our community safe.'),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showMessageOptions(Map<String, dynamic> message) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => MessageOptionsWidget(
        message: message,
        onDelete: () => _deleteMessage(message["id"] as String),
        onReport: () => _reportMessage(message["id"] as String),
      ),
    );
  }

  void _showProfileModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildProfileModal(),
    );
  }

  Widget _buildProfileModal() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(4.w),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2.w),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 15.w,
                    backgroundImage:
                        NetworkImage(_matchProfile["profileImage"] as String),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    _matchProfile["name"] as String,
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    _matchProfile["isOnline"] as bool ? 'Online' : 'Offline',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: (_matchProfile["isOnline"] as bool)
                          ? Colors.green
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                                context, '/user-profile-screen');
                          },
                          icon: CustomIconWidget(
                            iconName: 'person',
                            size: 5.w,
                            color: Colors.white,
                          ),
                          label: const Text('View Profile'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _showUnmatchDialog();
                          },
                          icon: CustomIconWidget(
                            iconName: 'block',
                            size: 5.w,
                            color: AppTheme.lightTheme.colorScheme.error,
                          ),
                          label: Text(
                            'Unmatch',
                            style: TextStyle(
                              color: AppTheme.lightTheme.colorScheme.error,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            side: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.error,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUnmatchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        title: Text(
          'Unmatch ${_matchProfile["name"]}?',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'This will remove ${_matchProfile["name"]} from your matches and delete your conversation. This action cannot be undone.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Unmatched with ${_matchProfile["name"]}'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: const Text('Unmatch'),
          ),
        ],
      ),
    );
  }

  void _showMenuOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2.w),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person',
                size: 6.w,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              title: Text(
                'View Profile',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                _showProfileModal();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'block',
                size: 6.w,
                color: AppTheme.lightTheme.colorScheme.error,
              ),
              title: Text(
                'Block User',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showUnmatchDialog();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Future<void> _loadMoreMessages() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate loading more messages
    await Future.delayed(const Duration(seconds: 1));

    final olderMessages = [
      {
        "id": "msg_old_1",
        "senderId": "user_2",
        "senderAvatar":
            "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
        "content": "Hi there! Nice to match with you 😊",
        "type": "text",
        "timestamp": DateTime.now().subtract(const Duration(days: 1)),
        "isDelivered": true,
        "isRead": true,
      },
      {
        "id": "msg_old_2",
        "senderId": "user_1",
        "senderAvatar":
            "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
        "content": "Hey! Thanks for the match. How's your day going?",
        "type": "text",
        "timestamp": DateTime.now().subtract(const Duration(days: 1, hours: 1)),
        "isDelivered": true,
        "isRead": true,
      },
    ];

    setState(() {
      _messages.insertAll(0, olderMessages);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: ChatHeaderWidget(
        matchProfile: _matchProfile,
        onBackPressed: () => Navigator.pop(context),
        onProfileTap: _showProfileModal,
        onMenuTap: _showMenuOptions,
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadMoreMessages,
              color: AppTheme.lightTheme.colorScheme.primary,
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(vertical: 1.h),
                itemCount: _messages.length +
                    (_isTyping ? 1 : 0) +
                    (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isLoading && index == 0) {
                    return Container(
                      padding: EdgeInsets.all(4.w),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    );
                  }

                  final messageIndex = _isLoading ? index - 1 : index;

                  if (_isTyping && messageIndex == _messages.length) {
                    return TypingIndicatorWidget(
                      userName: _matchProfile["name"] as String,
                    );
                  }

                  if (messageIndex >= _messages.length)
                    return const SizedBox.shrink();

                  final message = _messages[messageIndex];
                  final isMe = message["senderId"] == _currentUserId;

                  return GestureDetector(
                    onLongPress: () => _showMessageOptions(message),
                    child: MessageBubbleWidget(
                      message: message,
                      isMe: isMe,
                    ),
                  );
                },
              ),
            ),
          ),
          ChatInputWidget(
            onSendMessage: _sendMessage,
            onSendImage: _sendImage,
            onTyping: _onTyping,
          ),
        ],
      ),
    );
  }
}
