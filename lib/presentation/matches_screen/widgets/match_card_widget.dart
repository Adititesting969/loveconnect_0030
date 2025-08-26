import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MatchCardWidget extends StatelessWidget {
  final Map<String, dynamic> match;
  final VoidCallback onTap;
  final VoidCallback onUnmatch;
  final VoidCallback onQuickMessage;

  const MatchCardWidget({
    Key? key,
    required this.match,
    required this.onTap,
    required this.onUnmatch,
    required this.onQuickMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasUnreadMessages = match['hasUnreadMessages'] ?? false;
    final String lastMessage = match['lastMessage'] ?? '';
    final String timeAgo = match['timeAgo'] ?? '';
    final bool isNewMatch = match['isNewMatch'] ?? false;

    return Dismissible(
      key: Key('match_${match['id']}'),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'chat',
              color: Colors.white,
              size: 6.w,
            ),
            SizedBox(height: 1.h),
            Text(
              'Message',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'close',
              color: Colors.white,
              size: 6.w,
            ),
            SizedBox(height: 1.h),
            Text(
              'Unmatch',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onUnmatch();
          return false;
        } else if (direction == DismissDirection.endToStart) {
          onQuickMessage();
          return false;
        }
        return false;
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: isNewMatch
                ? Border.all(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    width: 2,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 15.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isNewMatch
                            ? AppTheme.lightTheme.colorScheme.secondary
                            : AppTheme.lightTheme.colorScheme.outline,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: CustomImageWidget(
                        imageUrl: match['profileImage'] ?? '',
                        width: 15.w,
                        height: 15.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (isNewMatch)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 4.w,
                        height: 4.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            match['name'] ?? 'Unknown',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: hasUnreadMessages
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            if (hasUnreadMessages)
                              Container(
                                width: 2.w,
                                height: 2.w,
                                margin: EdgeInsets.only(right: 2.w),
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            Text(
                              timeAgo,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: hasUnreadMessages
                                    ? AppTheme.lightTheme.colorScheme.secondary
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                fontWeight: hasUnreadMessages
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    if (lastMessage.isNotEmpty)
                      Text(
                        lastMessage,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: hasUnreadMessages
                              ? AppTheme.lightTheme.colorScheme.onSurface
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight: hasUnreadMessages
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    else
                      Text(
                        isNewMatch
                            ? 'You have a new match!'
                            : 'Start a conversation',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              ),
              CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
