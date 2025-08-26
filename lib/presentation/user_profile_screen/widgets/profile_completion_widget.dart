import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileCompletionWidget extends StatelessWidget {
  final int completion;
  final VoidCallback onTap;

  const ProfileCompletionWidget({
    Key? key,
    required this.completion,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getCompletionColor().withAlpha(77),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 12.w,
                  height: 12.w,
                  child: CircularProgressIndicator(
                    value: completion / 100,
                    strokeWidth: 3,
                    backgroundColor:
                        AppTheme.lightTheme.colorScheme.outline.withAlpha(77),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(_getCompletionColor()),
                  ),
                ),
                Text(
                  '$completion%',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
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
                    'Profile Completion',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    _getCompletionMessage(),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Color _getCompletionColor() {
    if (completion >= 90) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    } else if (completion >= 70) {
      return const Color(0xFFF59E0B); // Amber
    } else {
      return AppTheme.lightTheme.colorScheme.error;
    }
  }

  String _getCompletionMessage() {
    if (completion >= 90) {
      return 'Great! Your profile looks amazing';
    } else if (completion >= 70) {
      return 'Almost done! Add a few more details';
    } else {
      return 'Complete your profile for better matches';
    }
  }
}
