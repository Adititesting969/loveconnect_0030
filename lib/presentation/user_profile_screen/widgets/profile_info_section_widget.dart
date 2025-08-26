import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileInfoSectionWidget extends StatelessWidget {
  final String title;
  final String? content;
  final List<String>? interests;
  final Map<String, String>? basicInfo;
  final VoidCallback onEdit;

  const ProfileInfoSectionWidget({
    Key? key,
    required this.title,
    this.content,
    this.interests,
    this.basicInfo,
    required this.onEdit,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: onEdit,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  child: CustomIconWidget(
                    iconName: 'edit',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          if (content != null) _buildContentSection(),
          if (interests != null) _buildInterestsSection(),
          if (basicInfo != null) _buildBasicInfoSection(),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Text(
      content!,
      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
        height: 1.5,
      ),
    );
  }

  Widget _buildInterestsSection() {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: interests!
          .map((interest) => Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        AppTheme.lightTheme.colorScheme.primary.withAlpha(77),
                    width: 1,
                  ),
                ),
                child: Text(
                  interest,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      children: basicInfo!.entries
          .map((entry) => Padding(
                padding: EdgeInsets.symmetric(vertical: 0.5.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 25.w,
                      child: Text(
                        entry.key,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
