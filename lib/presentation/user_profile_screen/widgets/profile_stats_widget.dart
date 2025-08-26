import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileStatsWidget extends StatelessWidget {
  final Map<String, int> stats;

  const ProfileStatsWidget({
    Key? key,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Matches',
            stats['matches'] ?? 0,
            'favorite',
            AppTheme.lightTheme.colorScheme.secondary,
          ),
          _buildVerticalDivider(),
          _buildStatItem(
            'Likes',
            stats['likes'] ?? 0,
            'thumb_up',
            AppTheme.lightTheme.colorScheme.tertiary,
          ),
          _buildVerticalDivider(),
          _buildStatItem(
            'Super Likes',
            stats['superLikes'] ?? 0,
            'star',
            const Color(0xFF3B82F6), // Blue
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, String iconName, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 24,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          count.toString(),
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 8.h,
      width: 1,
      color: AppTheme.lightTheme.dividerColor,
    );
  }
}
