import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfilePhotoGridWidget extends StatelessWidget {
  final List<String?> photos;
  final Function(int) onPhotoTap;
  final VoidCallback onAddPhoto;
  final VoidCallback onEditPhotos;

  const ProfilePhotoGridWidget({
    Key? key,
    required this.photos,
    required this.onPhotoTap,
    required this.onAddPhoto,
    required this.onEditPhotos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Photos',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: onEditPhotos,
                child: Text(
                  'Edit Photos',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2.w,
              mainAxisSpacing: 2.w,
              childAspectRatio: 0.75,
            ),
            itemCount: 6, // 2x3 grid
            itemBuilder: (context, index) {
              final photo = index < photos.length ? photos[index] : null;

              if (photo != null) {
                return _buildPhotoCard(context, photo, index);
              } else {
                return _buildAddPhotoCard(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(BuildContext context, String photo, int index) {
    return GestureDetector(
      onTap: () => onPhotoTap(index),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildImage(photo),
              if (index == 0)
                Positioned(
                  top: 2.w,
                  left: 2.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(153),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'MAIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 2.w,
                right: 2.w,
                child: Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(153),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomIconWidget(
                    iconName: 'more_vert',
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String photo) {
    if (photo.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: photo,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppTheme.lightTheme.colorScheme.surface,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppTheme.lightTheme.colorScheme.surface,
          child: Center(
            child: CustomIconWidget(
              iconName: 'broken_image',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 32,
            ),
          ),
        ),
      );
    } else {
      // Local file path
      return Image.asset(
        'assets/images/no-image.jpg', // Placeholder for local images
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppTheme.lightTheme.colorScheme.surface,
          child: Center(
            child: CustomIconWidget(
              iconName: 'broken_image',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 32,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildAddPhotoCard(BuildContext context) {
    return GestureDetector(
      onTap: onAddPhoto,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'add_a_photo',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Add Photo',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
