import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginWidget extends StatelessWidget {
  final VoidCallback? onGoogleLogin;
  final VoidCallback? onAppleLogin;
  final VoidCallback? onFacebookLogin;

  const SocialLoginWidget({
    super.key,
    this.onGoogleLogin,
    this.onAppleLogin,
    this.onFacebookLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Or continue with',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSocialButton(
              onTap: onGoogleLogin,
              iconName: 'g_translate',
              label: 'Google',
            ),
            _buildSocialButton(
              onTap: onAppleLogin,
              iconName: 'apple',
              label: 'Apple',
            ),
            _buildSocialButton(
              onTap: onFacebookLogin,
              iconName: 'facebook',
              label: 'Facebook',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required VoidCallback? onTap,
    required String iconName,
    required String label,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 25.w,
        height: 6.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: AppTheme.lightTheme.colorScheme.surface,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
