import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/photo_carousel_widget.dart';
import './widgets/photo_viewer_widget.dart';
import './widgets/profile_info_widget.dart';

class ProfileDetailModal extends StatefulWidget {
  const ProfileDetailModal({Key? key}) : super(key: key);

  @override
  State<ProfileDetailModal> createState() => _ProfileDetailModalState();
}

class _ProfileDetailModalState extends State<ProfileDetailModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late ScrollController _scrollController;
  bool _isBioExpanded = false;

  // Mock profile data
  final Map<String, dynamic> _profileData = {
    "id": 1,
    "name": "Emma Rodriguez",
    "age": 28,
    "distance": 2.3,
    "bio":
        "Adventure seeker and coffee enthusiast ☕ Love exploring new places, trying different cuisines, and meeting interesting people. Currently working as a graphic designer and passionate about sustainable living. Looking for someone who shares my love for spontaneous road trips and deep conversations under the stars. Life's too short for boring dates!",
    "isVerified": true,
    "education": "Bachelor's in Graphic Design, Art Institute",
    "work": "Senior Graphic Designer at Creative Studios",
    "interests": [
      "Travel",
      "Photography",
      "Fitness",
      "Music",
      "Art",
      "Hiking",
      "Cooking",
      "Yoga"
    ],
    "photos": [
      "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=800",
      "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=800",
      "https://images.pexels.com/photos/1542085/pexels-photo-1542085.jpeg?auto=compress&cs=tinysrgb&w=800",
      "https://images.pexels.com/photos/1858175/pexels-photo-1858175.jpeg?auto=compress&cs=tinysrgb&w=800",
      "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=800",
    ],
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _scrollController = ScrollController();

    // Start animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _closeModal() {
    _animationController.reverse().then((_) {
      Navigator.pop(context);
    });
  }

  void _onPhotoTap(int index) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: PhotoViewerWidget(
              photos: (_profileData['photos'] as List).cast<String>(),
              initialIndex: index,
              onClose: () => Navigator.pop(context),
              onReport: (photoUrl) {
                // Handle photo report
                print('Reported photo: $photoUrl');
              },
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _onPass() {
    _closeModal();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Passed on ${_profileData['name']}'),
        backgroundColor: Colors.grey.shade600,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onLike() {
    _closeModal();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Liked ${_profileData['name']}! 💕'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onSuperLike() {
    _closeModal();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Super Liked ${_profileData['name']}! ⭐'),
        backgroundColor: const Color(0xFF4FC3F7),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Report User',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Why are you reporting this user?',
              style: AppTheme.lightTheme.textTheme.bodyLarge,
            ),
            SizedBox(height: 2.h),
            ...[
              'Inappropriate photos',
              'Fake profile',
              'Harassment',
              'Spam',
              'Other'
            ].map((reason) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    reason,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('User reported for: $reason'),
                        backgroundColor: AppTheme.lightTheme.colorScheme.error,
                      ),
                    );
                  },
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Block User',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to block ${_profileData['name']}? You won\'t see their profile again.',
          style: AppTheme.lightTheme.textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _closeModal();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${_profileData['name']} has been blocked'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
              );
            },
            child: Text(
              'Block',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! > 300) {
            _closeModal();
          }
        },
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6.w),
                topRight: Radius.circular(6.w),
              ),
            ),
            child: Column(
              children: [
                // Top handle bar
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Center(
                    child: Container(
                      width: 12.w,
                      height: 0.5.h,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        borderRadius: BorderRadius.circular(1.h),
                      ),
                    ),
                  ),
                ),

                // Header with close button and menu
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _closeModal,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline,
                              width: 1,
                            ),
                          ),
                          child: CustomIconWidget(
                            iconName: 'keyboard_arrow_down',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 6.w,
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline,
                              width: 1,
                            ),
                          ),
                          child: CustomIconWidget(
                            iconName: 'more_vert',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 6.w,
                          ),
                        ),
                        color: AppTheme.lightTheme.colorScheme.surface,
                        onSelected: (value) {
                          if (value == 'report') {
                            _showReportDialog();
                          } else if (value == 'block') {
                            _showBlockDialog();
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'report',
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'report',
                                  color: AppTheme.lightTheme.colorScheme.error,
                                  size: 5.w,
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  'Report',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'block',
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'block',
                                  color: AppTheme.lightTheme.colorScheme.error,
                                  size: 5.w,
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  'Block',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        // Photo carousel
                        PhotoCarouselWidget(
                          photos:
                              (_profileData['photos'] as List).cast<String>(),
                          onPhotoTap: _onPhotoTap,
                        ),

                        // Profile information
                        ProfileInfoWidget(
                          profileData: _profileData,
                          isBioExpanded: _isBioExpanded,
                          onBioExpand: () {
                            setState(() {
                              _isBioExpanded = !_isBioExpanded;
                            });
                          },
                        ),

                        // Bottom spacing for action buttons
                        SizedBox(height: 12.h),
                      ],
                    ),
                  ),
                ),

                // Action buttons
                ActionButtonsWidget(
                  onPass: _onPass,
                  onLike: _onLike,
                  onSuperLike: _onSuperLike,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
