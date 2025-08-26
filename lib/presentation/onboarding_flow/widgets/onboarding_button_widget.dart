import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class OnboardingButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const OnboardingButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 6.h,
      constraints: BoxConstraints(
        minHeight: 48,
        maxHeight: 60,
      ),
      child: isPrimary
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                elevation: 2,
                shadowColor: AppTheme.lightTheme.colorScheme.shadow,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                text,
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          : TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.lightTheme.colorScheme.primary,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                text,
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
    );
  }
}
