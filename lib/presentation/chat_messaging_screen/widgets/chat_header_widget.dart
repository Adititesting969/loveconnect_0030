import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  final Map<String, dynamic> matchProfile;
  final VoidCallback onBackPressed;
  final VoidCallback onProfileTap;
  final VoidCallback onMenuTap;

  const ChatHeaderWidget({
    Key? key,
    required this.matchProfile,
    required this.onBackPressed,
    required this.onProfileTap,
    required this.onMenuTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOnline = matchProfile['isOnline'] as bool? ?? false;
    final lastSeen = matchProfile['lastSeen'] as DateTime?;

    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      leading: GestureDetector(
        onTap: onBackPressed,
        child: Container(
          margin: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: CustomIconWidget(
            iconName: 'arrow_back_ios',
            size: 5.w,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
      ),
      title: GestureDetector(
        onTap: onProfileTap,
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 5.w,
                  backgroundImage: NetworkImage(
                    matchProfile['profileImage'] as String? ?? '',
                  ),
                ),
                if (isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 3.w,
                      height: 3.w,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    matchProfile['name'] as String? ?? 'Unknown',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    _getStatusText(isOnline, lastSeen),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: isOnline
                          ? Colors.green
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          onTap: onMenuTap,
          child: Container(
            margin: EdgeInsets.all(2.w),
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: CustomIconWidget(
              iconName: 'more_vert',
              size: 5.w,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  String _getStatusText(bool isOnline, DateTime? lastSeen) {
    if (isOnline) {
      return 'Online';
    } else if (lastSeen != null) {
      final now = DateTime.now();
      final difference = now.difference(lastSeen);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return 'Last seen ${lastSeen.day}/${lastSeen.month}';
      }
    }
    return 'Offline';
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
