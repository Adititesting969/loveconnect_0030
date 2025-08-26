import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickMessageModal extends StatelessWidget {
  final String matchName;
  final Function(String) onSendMessage;

  const QuickMessageModal({
    Key? key,
    required this.matchName,
    required this.onSendMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> quickMessages = [
      'Hey! How\'s your day going? 😊',
      'I love your profile! Tell me more about yourself',
      'What\'s your favorite way to spend weekends?',
      'Coffee or tea? ☕',
      'I noticed we have similar interests!',
      'What\'s the best book you\'ve read recently?',
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Send a quick message to $matchName',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Choose a conversation starter:',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: quickMessages.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  onSendMessage(quickMessages[index]);
                },
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          quickMessages[index],
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ),
                      CustomIconWidget(
                        iconName: 'send',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 5.w,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
