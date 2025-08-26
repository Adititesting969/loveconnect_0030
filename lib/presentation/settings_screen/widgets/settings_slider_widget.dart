import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsSliderWidget extends StatelessWidget {
  final String iconName;
  final String title;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String Function(double) valueFormatter;
  final ValueChanged<double> onChanged;
  final bool showDivider;

  const SettingsSliderWidget({
    Key? key,
    required this.iconName,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.valueFormatter,
    required this.onChanged,
    this.showDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: iconName,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    valueFormatter(value),
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppTheme.lightTheme.colorScheme.primary,
                  inactiveTrackColor: AppTheme.lightTheme.dividerColor,
                  thumbColor: AppTheme.lightTheme.colorScheme.primary,
                  overlayColor: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.2),
                  valueIndicatorColor: AppTheme.lightTheme.colorScheme.primary,
                  trackHeight: 4,
                ),
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  divisions: divisions,
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.5,
            indent: 4.w,
            endIndent: 4.w,
            color: AppTheme.lightTheme.dividerColor,
          ),
      ],
    );
  }
}
