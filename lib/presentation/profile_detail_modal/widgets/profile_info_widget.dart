import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ProfileInfoWidget extends StatelessWidget {
  final Map<String, dynamic> profileData;
  final Function()? onBioExpand;
  final bool isBioExpanded;

  const ProfileInfoWidget({
    Key? key,
    required this.profileData,
    this.onBioExpand,
    this.isBioExpanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String name = profileData['name'] ?? '';
    final int age = profileData['age'] ?? 0;
    final double distance = (profileData['distance'] ?? 0.0).toDouble();
    final String bio = profileData['bio'] ?? '';
    final bool isVerified = profileData['isVerified'] ?? false;
    final String education = profileData['education'] ?? '';
    final String work = profileData['work'] ?? '';
    final List<String> interests =
        (profileData['interests'] as List?)?.cast<String>() ?? [];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name, age, distance header
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      '$name, $age',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    if (isVerified) ...[
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'verified',
                          color: Colors.white,
                          size: 4.w,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(4.w),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'location_on',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${distance.toStringAsFixed(1)} km',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Bio section
          if (bio.isNotEmpty) ...[
            GestureDetector(
              onTap: onBioExpand,
              child: Container(
                width: double.infinity,
                child: Text(
                  bio,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    height: 1.5,
                  ),
                  maxLines: isBioExpanded ? null : 3,
                  overflow: isBioExpanded ? null : TextOverflow.ellipsis,
                ),
              ),
            ),
            if (bio.length > 150 && !isBioExpanded) ...[
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: onBioExpand,
                child: Text(
                  'Read more',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            SizedBox(height: 3.h),
          ],

          // Education and work
          if (education.isNotEmpty || work.isNotEmpty) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (education.isNotEmpty) ...[
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'school',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          education,
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                ],
                if (work.isNotEmpty) ...[
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'work',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          work,
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                ],
              ],
            ),
            SizedBox(height: 2.h),
          ],

          // Interests section
          if (interests.isNotEmpty) ...[
            Text(
              'Interests',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: interests.map((interest) {
                final bool isShared = _isSharedInterest(interest);
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: isShared
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(6.w),
                    border: Border.all(
                      color: isShared
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: isShared ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    interest,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: isShared
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: isShared ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  bool _isSharedInterest(String interest) {
    // Mock shared interests for demonstration
    final List<String> userInterests = [
      'Travel',
      'Photography',
      'Fitness',
      'Music'
    ];
    return userInterests.contains(interest);
  }
}
