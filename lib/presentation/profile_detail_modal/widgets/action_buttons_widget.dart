import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final Function()? onPass;
  final Function()? onLike;
  final Function()? onSuperLike;

  const ActionButtonsWidget({
    Key? key,
    this.onPass,
    this.onLike,
    this.onSuperLike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Pass button
            GestureDetector(
              onTap: onPass,
              child: Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: Colors.grey.shade600,
                    size: 7.w,
                  ),
                ),
              ),
            ),

            // Super like button
            GestureDetector(
              onTap: onSuperLike,
              child: Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF4FC3F7),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4FC3F7).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'star',
                    color: const Color(0xFF4FC3F7),
                    size: 7.w,
                  ),
                ),
              ),
            ),

            // Like button
            GestureDetector(
              onTap: onLike,
              child: Container(
                width: 18.w,
                height: 18.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'favorite',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 8.w,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
