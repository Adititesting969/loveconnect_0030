import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback? onPass;
  final VoidCallback? onSuperLike;
  final VoidCallback? onLike;

  const ActionButtonsWidget({
    Key? key,
    this.onPass,
    this.onSuperLike,
    this.onLike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Pass Button
          _buildActionButton(
            onTap: onPass,
            icon: 'close',
            color: AppTheme.lightTheme.colorScheme.error,
            size: 12.w,
            iconSize: 28,
          ),

          // Super Like Button
          _buildActionButton(
            onTap: onSuperLike,
            icon: 'star',
            color: AppTheme.lightTheme.colorScheme.tertiary,
            size: 10.w,
            iconSize: 24,
          ),

          // Like Button
          _buildActionButton(
            onTap: onLike,
            icon: 'favorite',
            color: AppTheme.lightTheme.colorScheme.secondary,
            size: 12.w,
            iconSize: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback? onTap,
    required String icon,
    required Color color,
    required double size,
    required double iconSize,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: color,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
