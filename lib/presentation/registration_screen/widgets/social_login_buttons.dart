import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final VoidCallback? onFacebookPressed;

  const SocialLoginButtons({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.onFacebookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Google Sign-In Button
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: OutlinedButton.icon(
            onPressed: onGooglePressed,
            icon: CustomIconWidget(
              iconName: 'g_translate',
              size: 20,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            label: Text(
              'Continue with Google',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              side: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),

        // Apple Sign-In Button (iOS priority)
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: OutlinedButton.icon(
            onPressed: onApplePressed,
            icon: CustomIconWidget(
              iconName: 'apple',
              size: 20,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            label: Text(
              'Continue with Apple',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              side: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),

        // Facebook Sign-In Button
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: OutlinedButton.icon(
            onPressed: onFacebookPressed,
            icon: CustomIconWidget(
              iconName: 'facebook',
              size: 20,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            label: Text(
              'Continue with Facebook',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              side: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
