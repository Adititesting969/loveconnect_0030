import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VerificationBadgeWidget extends StatelessWidget {
  final VoidCallback onTap;

  const VerificationBadgeWidget({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.lightTheme.colorScheme.tertiary,
              AppTheme.lightTheme.colorScheme.tertiary.withAlpha(204),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.tertiary.withAlpha(77),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'verified',
              color: Colors.white,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              'Verified',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
