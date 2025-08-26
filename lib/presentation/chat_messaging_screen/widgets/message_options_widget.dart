import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageOptionsWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final VoidCallback onDelete;
  final VoidCallback onReport;

  const MessageOptionsWidget({
    Key? key,
    required this.message,
    required this.onDelete,
    required this.onReport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2.w),
            ),
          ),
          SizedBox(height: 3.h),
          _buildOptionTile(
            icon: 'content_copy',
            title: 'Copy',
            onTap: () {
              Navigator.pop(context);
              _copyMessage();
            },
          ),
          _buildOptionTile(
            icon: 'delete_outline',
            title: 'Delete',
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmation(context);
            },
            isDestructive: true,
          ),
          _buildOptionTile(
            icon: 'report_outlined',
            title: 'Report',
            onTap: () {
              Navigator.pop(context);
              _showReportConfirmation(context);
            },
            isDestructive: true,
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        size: 6.w,
        color: isDestructive
            ? AppTheme.lightTheme.colorScheme.error
            : AppTheme.lightTheme.colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color: isDestructive
              ? AppTheme.lightTheme.colorScheme.error
              : AppTheme.lightTheme.colorScheme.onSurface,
          fontSize: 16.sp,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.w),
      ),
    );
  }

  void _copyMessage() {
    final content = message['content'] as String? ?? '';
    if (content.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: content));
      // Show success feedback
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        title: Text(
          'Delete Message',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to delete this message? This action cannot be undone.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showReportConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        title: Text(
          'Report Message',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to report this message? Our team will review it for violations of community guidelines.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onReport();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }
}
