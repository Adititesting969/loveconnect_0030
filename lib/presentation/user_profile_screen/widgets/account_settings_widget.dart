import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AccountSettingsWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onVerificationTap;
  final VoidCallback onSubscriptionTap;

  const AccountSettingsWidget({
    Key? key,
    required this.userData,
    required this.onVerificationTap,
    required this.onSubscriptionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
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
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Account',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildAccountItem(
            iconName: 'email',
            title: 'Email',
            subtitle: userData['email'] as String,
          ),
          _buildAccountItem(
            iconName: 'phone',
            title: 'Phone',
            subtitle: userData['phone'] as String,
          ),
          _buildAccountItem(
            iconName: 'calendar_today',
            title: 'Member Since',
            subtitle: userData['joinDate'] as String,
          ),
          _buildAccountItem(
            iconName: 'verified',
            title: 'Verification Status',
            subtitle:
                (userData['isVerified'] as bool) ? 'Verified' : 'Not Verified',
            trailing: (userData['isVerified'] as bool)
                ? CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 20,
                  )
                : TextButton(
                    onPressed: onVerificationTap,
                    child: Text('Verify'),
                  ),
            onTap: onVerificationTap,
          ),
          _buildAccountItem(
            iconName: 'star',
            title: 'Subscription',
            subtitle: (userData['isPremium'] as bool)
                ? 'Premium Active'
                : 'Free Account',
            trailing: !(userData['isPremium'] as bool)
                ? TextButton(
                    onPressed: onSubscriptionTap,
                    child: Text('Upgrade'),
                  )
                : null,
            onTap: onSubscriptionTap,
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountItem({
    required String iconName,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: iconName,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        subtitle,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
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
