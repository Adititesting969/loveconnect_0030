import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsToggleWidget extends StatelessWidget {
  final String iconName;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  const SettingsToggleWidget({
    Key? key,
    required this.iconName,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 0.5.h),
                      Text(
                        subtitle!,
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 2.w),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: AppTheme.lightTheme.colorScheme.primary,
                inactiveThumbColor:
                    AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                inactiveTrackColor: AppTheme.lightTheme.dividerColor,
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.5,
            indent: 4.w + 24 + 3.w,
            endIndent: 4.w,
            color: AppTheme.lightTheme.dividerColor,
          ),
      ],
    );
  }
}
