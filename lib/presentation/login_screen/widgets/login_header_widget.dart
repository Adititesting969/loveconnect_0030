import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Logo
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.lightTheme.colorScheme.secondary,
                AppTheme.lightTheme.colorScheme.tertiary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'favorite',
              size: 10.w,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 3.h),

        // Welcome Text
        Text(
          'Welcome Back!',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 1.h),

        // Subtitle
        Text(
          'Sign in to continue your journey',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
