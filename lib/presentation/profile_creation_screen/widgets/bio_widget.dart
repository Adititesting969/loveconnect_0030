import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BioWidget extends StatefulWidget {
  final TextEditingController bioController;

  const BioWidget({
    Key? key,
    required this.bioController,
  }) : super(key: key);

  @override
  State<BioWidget> createState() => _BioWidgetState();
}

class _BioWidgetState extends State<BioWidget> {
  static const int maxCharacters = 500;
  int _currentLength = 0;

  @override
  void initState() {
    super.initState();
    _currentLength = widget.bioController.text.length;
    widget.bioController.addListener(_updateCharacterCount);
  }

  @override
  void dispose() {
    widget.bioController.removeListener(_updateCharacterCount);
    super.dispose();
  }

  void _updateCharacterCount() {
    setState(() {
      _currentLength = widget.bioController.text.length;
    });
  }

  Color _getCounterColor() {
    if (_currentLength >= maxCharacters) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (_currentLength >= maxCharacters * 0.8) {
      return AppTheme.warningLight;
    }
    return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: AppTheme.lightTheme.colorScheme.shadow,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'About Me',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '$_currentLength/$maxCharacters',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: _getCounterColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              'Tell others about yourself and what you\'re looking for',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),
            TextFormField(
              controller: widget.bioController,
              maxLines: 6,
              maxLength: maxCharacters,
              decoration: InputDecoration(
                hintText:
                    'I love traveling, trying new restaurants, and spending time outdoors. Looking for someone who shares my passion for adventure and good conversation...',
                hintMaxLines: 4,
                counterText: '', // Hide default counter
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.all(4.w),
              ),
              textInputAction: TextInputAction.newline,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please write something about yourself';
                }
                if (value.trim().length < 20) {
                  return 'Bio should be at least 20 characters';
                }
                return null;
              },
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'lightbulb_outline',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Tip: Be authentic and specific about your interests',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontStyle: FontStyle.italic,
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
