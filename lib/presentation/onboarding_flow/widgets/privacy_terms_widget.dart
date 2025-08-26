import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrivacyTermsWidget extends StatefulWidget {
  final Function(bool) onPrivacyChanged;
  final Function(bool) onTermsChanged;
  final bool privacyAccepted;
  final bool termsAccepted;

  const PrivacyTermsWidget({
    Key? key,
    required this.onPrivacyChanged,
    required this.onTermsChanged,
    required this.privacyAccepted,
    required this.termsAccepted,
  }) : super(key: key);

  @override
  State<PrivacyTermsWidget> createState() => _PrivacyTermsWidgetState();
}

class _PrivacyTermsWidgetState extends State<PrivacyTermsWidget> {
  void _showPrivacyPolicy() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: 80.h,
        padding: EdgeInsets.all(6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Privacy Policy',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  '''Your privacy is important to us. This Privacy Policy explains how LoveConnect collects, uses, and protects your information when you use our dating application.

Information We Collect:
• Profile information (name, age, photos, bio)
• Location data for matching purposes
• Usage data and app interactions
• Messages and communications
• Device information and identifiers

How We Use Your Information:
• To provide and improve our matching services
• To facilitate connections between users
• To ensure safety and security
• To send notifications about matches and messages
• To analyze app usage and performance

Data Protection:
• We use industry-standard encryption
• Your data is stored securely on protected servers
• We never sell your personal information
• You can delete your account and data at any time

Contact Us:
If you have questions about this Privacy Policy, please contact us at privacy@loveconnect.com

Last updated: August 26, 2025''',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTermsOfService() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: 80.h,
        padding: EdgeInsets.all(6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Terms of Service',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  '''Welcome to LoveConnect. By using our app, you agree to these Terms of Service.

Eligibility:
• You must be at least 18 years old
• You must provide accurate information
• One account per person
• You are responsible for your account security

User Conduct:
• Be respectful and kind to other users
• No harassment, bullying, or inappropriate behavior
• No fake profiles or impersonation
• No spam or commercial solicitation
• Report any suspicious or harmful activity

Content Guidelines:
• Profile photos must be appropriate and of yourself
• No nudity or sexually explicit content
• No hate speech or discriminatory language
• We reserve the right to remove inappropriate content

Safety:
• Meet in public places for first dates
• Trust your instincts and prioritize your safety
• Use the app's reporting and blocking features
• We are not responsible for offline interactions

Account Termination:
• You may delete your account at any time
• We may suspend accounts that violate these terms
• Deleted accounts cannot be recovered

Contact Us:
For questions about these Terms, contact us at support@loveconnect.com

Last updated: August 26, 2025''',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Privacy Policy Checkbox
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: widget.privacyAccepted,
              onChanged: (value) => widget.onPrivacyChanged(value ?? false),
              fillColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.lightTheme.colorScheme.primary;
                }
                return Colors.transparent;
              }),
              checkColor: AppTheme.lightTheme.colorScheme.onPrimary,
              side: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: _showPrivacyPolicy,
                child: Padding(
                  padding: EdgeInsets.only(top: 1.5.h),
                  child: RichText(
                    text: TextSpan(
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(
                          text: 'I agree to the ',
                          style: TextStyle(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 1.h),

        // Terms of Service Checkbox
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: widget.termsAccepted,
              onChanged: (value) => widget.onTermsChanged(value ?? false),
              fillColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.lightTheme.colorScheme.primary;
                }
                return Colors.transparent;
              }),
              checkColor: AppTheme.lightTheme.colorScheme.onPrimary,
              side: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: _showTermsOfService,
                child: Padding(
                  padding: EdgeInsets.only(top: 1.5.h),
                  child: RichText(
                    text: TextSpan(
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(
                          text: 'I agree to the ',
                          style: TextStyle(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
