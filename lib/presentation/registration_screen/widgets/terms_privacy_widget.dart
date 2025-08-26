import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TermsPrivacyWidget extends StatelessWidget {
  final bool isAgreed;
  final ValueChanged<bool?> onChanged;
  final VoidCallback? onTermsPressed;
  final VoidCallback? onPrivacyPressed;

  const TermsPrivacyWidget({
    super.key,
    required this.isAgreed,
    required this.onChanged,
    this.onTermsPressed,
    this.onPrivacyPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: isAgreed,
          onChanged: onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              children: [
                const TextSpan(
                    text: 'By creating an account, you agree to our '),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: onTermsPressed,
                    child: Text(
                      'Terms of Service',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const TextSpan(text: ' and '),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: onPrivacyPressed,
                    child: Text(
                      'Privacy Policy',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
