import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback? onRefresh;
  final VoidCallback? onAdjustFilters;

  const EmptyStateWidget({
    Key? key,
    this.onRefresh,
    this.onAdjustFilters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty State Icon
            Container(
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'search_off',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 40,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              'No More Profiles',
              style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Description
            Text(
              'You\'ve seen everyone in your area! Try expanding your search criteria or check back later for new profiles.',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Action Buttons
            Column(
              children: [
                // Refresh Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onRefresh,
                    icon: CustomIconWidget(
                      iconName: 'refresh',
                      color: Colors.white,
                      size: 20,
                    ),
                    label: Text('Refresh'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Adjust Filters Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onAdjustFilters,
                    icon: CustomIconWidget(
                      iconName: 'tune',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    label: Text('Adjust Filters'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
