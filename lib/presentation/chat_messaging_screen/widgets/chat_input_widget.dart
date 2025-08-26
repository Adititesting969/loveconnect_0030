import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatInputWidget extends StatefulWidget {
  final Function(String) onSendMessage;
  final Function(String, String?) onSendImage;
  final VoidCallback? onTyping;

  const ChatInputWidget({
    Key? key,
    required this.onSendMessage,
    required this.onSendImage,
    this.onTyping,
  }) : super(key: key);

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final isCurrentlyTyping = _messageController.text.trim().isNotEmpty;
    if (isCurrentlyTyping != _isTyping) {
      setState(() {
        _isTyping = isCurrentlyTyping;
      });
      if (isCurrentlyTyping && widget.onTyping != null) {
        widget.onTyping!();
      }
    }
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      widget.onSendMessage(message);
      _messageController.clear();
      setState(() {
        _isTyping = false;
      });
    }
  }

  Future<void> _showImagePicker() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(
                  icon: 'camera_alt',
                  label: 'Camera',
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                _buildImageOption(
                  icon: 'photo_library',
                  label: 'Gallery',
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4.w),
            ),
            child: CustomIconWidget(
              iconName: icon,
              size: 6.w,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        // Show caption dialog
        _showCaptionDialog(image.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: ${e.toString()}'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  void _showCaptionDialog(String imagePath) {
    final TextEditingController captionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        title: Text(
          'Add Caption',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2.w),
              child: CustomImageWidget(
                imageUrl: imagePath,
                width: 60.w,
                height: 20.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: captionController,
              decoration: InputDecoration(
                hintText: 'Add a caption...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              maxLines: 3,
            ),
          ],
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
              widget.onSendImage(imagePath, captionController.text.trim());
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            GestureDetector(
              onTap: _showImagePicker,
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: CustomIconWidget(
                  iconName: 'add_photo_alternate',
                  size: 5.w,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Container(
                constraints: BoxConstraints(maxHeight: 12.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(6.w),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle:
                        AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                  ),
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  maxLines: 4,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            GestureDetector(
              onTap: _isTyping ? _sendMessage : null,
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: _isTyping
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: CustomIconWidget(
                  iconName: 'send',
                  size: 5.w,
                  color: _isTyping
                      ? Colors.white
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
