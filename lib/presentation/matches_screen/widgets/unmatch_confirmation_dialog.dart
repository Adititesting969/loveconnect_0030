import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UnmatchConfirmationDialog extends StatelessWidget {
  final String matchName;
  final VoidCallback onConfirm;

  const UnmatchConfirmationDialog({
    Key? key,
    required this.matchName,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: EdgeInsets.all(6.w),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color:
                  AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'heart_broken',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 10.w,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Unmatch with $matchName?',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            'This action cannot be undone. You won\'t be able to see each other\'s profiles or send messages anymore.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.error,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: Text(
                    'Unmatch',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
