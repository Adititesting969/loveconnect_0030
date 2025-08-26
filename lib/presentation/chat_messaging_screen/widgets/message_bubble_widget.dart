import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageBubbleWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isMe;

  const MessageBubbleWidget({
    Key? key,
    required this.message,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageType = message['type'] as String? ?? 'text';
    final timestamp = message['timestamp'] as DateTime;
    final isDelivered = message['isDelivered'] as bool? ?? false;
    final isRead = message['isRead'] as bool? ?? false;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 4.w),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 2.5.w,
              backgroundImage:
                  NetworkImage(message['senderAvatar'] as String? ?? ''),
            ),
            SizedBox(width: 2.w),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 70.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: isMe
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.w),
                      topRight: Radius.circular(4.w),
                      bottomLeft:
                          isMe ? Radius.circular(4.w) : Radius.circular(1.w),
                      bottomRight:
                          isMe ? Radius.circular(1.w) : Radius.circular(4.w),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: messageType == 'image'
                      ? _buildImageMessage()
                      : _buildTextMessage(),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(timestamp),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontSize: 10.sp,
                      ),
                    ),
                    if (isMe) ...[
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                        iconName: isRead
                            ? 'done_all'
                            : (isDelivered ? 'done' : 'schedule'),
                        size: 12.sp,
                        color: isRead
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (isMe) ...[
            SizedBox(width: 2.w),
            CircleAvatar(
              radius: 2.5.w,
              backgroundImage:
                  NetworkImage(message['senderAvatar'] as String? ?? ''),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextMessage() {
    return Text(
      message['content'] as String,
      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
        color: isMe ? Colors.white : AppTheme.lightTheme.colorScheme.onSurface,
        fontSize: 14.sp,
      ),
    );
  }

  Widget _buildImageMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2.w),
          child: CustomImageWidget(
            imageUrl: message['imageUrl'] as String,
            width: 50.w,
            height: 30.h,
            fit: BoxFit.cover,
          ),
        ),
        if (message['caption'] != null &&
            (message['caption'] as String).isNotEmpty) ...[
          SizedBox(height: 1.h),
          Text(
            message['caption'] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: isMe
                  ? Colors.white
                  : AppTheme.lightTheme.colorScheme.onSurface,
              fontSize: 14.sp,
            ),
          ),
        ],
      ],
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${timestamp.day}/${timestamp.month}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }
}
