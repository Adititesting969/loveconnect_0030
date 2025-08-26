import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final double progress;
  final int currentStep;
  final int totalSteps;

  const ProgressIndicatorWidget({
    Key? key,
    required this.progress,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile Setup',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(progress * 100).round()}% Complete',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 0.8.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 92.w * progress,
                height: 0.8.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.lightTheme.colorScheme.primary,
                      AppTheme.lightTheme.colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalSteps, (index) {
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep - 1;

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                child: Row(
                  children: [
                    Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted || isCurrent
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.5),
                      ),
                    ),
                    if (index < totalSteps - 1)
                      Container(
                        width: 4.w,
                        height: 0.2.h,
                        color: isCompleted
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
