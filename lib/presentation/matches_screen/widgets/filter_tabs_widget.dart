import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterTabsWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final List<String> tabs;

  const FilterTabsWidget({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.tabs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final bool isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onTabSelected(index),
            child: Container(
              margin: EdgeInsets.only(right: 2.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  tabs[index],
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
