
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/account_settings_widget.dart';
import './widgets/profile_completion_widget.dart';
import './widgets/profile_info_section_widget.dart';
import './widgets/profile_photo_grid_widget.dart';
import './widgets/profile_stats_widget.dart';
import './widgets/verification_badge_widget.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  // Mock user data - in real app, this would come from a state manager or API
  final Map<String, dynamic> _userData = {
    "name": "Sarah Johnson",
    "age": 28,
    "profession": "Software Engineer",
    "location": "San Francisco, CA",
    "bio":
        "Adventure seeker, coffee enthusiast, and dog lover. Looking for someone to explore the world with 🌍",
    "interests": [
      "Travel",
      "Photography",
      "Hiking",
      "Coffee",
      "Dogs",
      "Technology"
    ],
    "email": "sarah.johnson@email.com",
    "phone": "+1 (555) 123-4567",
    "isPremium": false,
    "isVerified": true,
    "joinDate": "March 2024",
    "profileCompletion": 85,
    "photos": [
      "https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg?auto=compress&cs=tinysrgb&w=400",
      "https://images.pexels.com/photos/1181686/pexels-photo-1181686.jpeg?auto=compress&cs=tinysrgb&w=400",
      "https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg?auto=compress&cs=tinysrgb&w=400",
      null, // Empty slot
      null, // Empty slot
      null, // Empty slot
    ],
    "stats": {
      "matches": 127,
      "likes": 243,
      "superLikes": 12,
    }
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 100 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProfileHeader(),
                _buildProfilePhotoGrid(),
                _buildProfileInfo(),
                _buildAccountSection(),
                _buildSettingsSection(),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor: _isScrolled
          ? AppTheme.lightTheme.scaffoldBackgroundColor.withAlpha(242)
          : Colors.transparent,
      elevation: _isScrolled ? 2 : 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color:
                _isScrolled ? Colors.transparent : Colors.black.withAlpha(77),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: 'arrow_back',
            color: _isScrolled
                ? AppTheme.lightTheme.colorScheme.onSurface
                : Colors.white,
            size: 20,
          ),
        ),
      ),
      title: _isScrolled
          ? Text(
              _userData['name'] as String,
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: _showEditOptions,
          icon: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color:
                  _isScrolled ? Colors.transparent : Colors.black.withAlpha(77),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: 'more_vert',
              color: _isScrolled
                  ? AppTheme.lightTheme.colorScheme.onSurface
                  : Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      child: Column(
        children: [
          ProfileCompletionWidget(
            completion: _userData['profileCompletion'] as int,
            onTap: _showCompletionTips,
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _userData['name'] as String,
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 2.w),
              if (_userData['isVerified'] as bool)
                VerificationBadgeWidget(
                  onTap: _showVerificationInfo,
                ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Text(
            "${_userData['age']} • ${_userData['profession']}",
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 0.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                _userData['location'] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (!(_userData['isPremium'] as bool)) ...[
            SizedBox(height: 2.h),
            _buildPremiumUpgradeBanner(),
          ],
        ],
      ),
    );
  }

  Widget _buildPremiumUpgradeBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.secondary,
            AppTheme.lightTheme.colorScheme.tertiary,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'star',
            color: Colors.white,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upgrade to Premium',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Get unlimited likes and see who liked you',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withAlpha(230),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _showPremiumUpgrade,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.lightTheme.colorScheme.secondary,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            ),
            child: Text('Upgrade'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePhotoGrid() {
    return ProfilePhotoGridWidget(
      photos: List<String?>.from(_userData['photos'] as List),
      onPhotoTap: _showPhotoViewer,
      onAddPhoto: _addPhoto,
      onEditPhotos: _editPhotos,
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        ProfileStatsWidget(
          stats: Map<String, int>.from(_userData['stats'] as Map),
        ),
        ProfileInfoSectionWidget(
          title: 'About Me',
          content: _userData['bio'] as String,
          onEdit: () => _editBio(),
        ),
        ProfileInfoSectionWidget(
          title: 'Interests',
          interests: List<String>.from(_userData['interests'] as List),
          onEdit: () => _editInterests(),
        ),
        ProfileInfoSectionWidget(
          title: 'Basic Info',
          basicInfo: {
            'Age': _userData['age'].toString(),
            'Profession': _userData['profession'] as String,
            'Location': _userData['location'] as String,
          },
          onEdit: () => _editBasicInfo(),
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return AccountSettingsWidget(
      userData: _userData,
      onVerificationTap: _showVerificationInfo,
      onSubscriptionTap: _showPremiumUpgrade,
    );
  }

  Widget _buildSettingsSection() {
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
        children: [
          _buildSettingsTile(
            iconName: 'lock',
            title: 'Privacy Controls',
            subtitle: 'Manage who can see your profile',
            onTap: () => Navigator.pushNamed(context, '/privacy-settings'),
          ),
          _buildSettingsTile(
            iconName: 'notifications',
            title: 'Notification Preferences',
            subtitle: 'Choose what notifications you receive',
            onTap: () => Navigator.pushNamed(context, '/notification-settings'),
          ),
          _buildSettingsTile(
            iconName: 'tune',
            title: 'Discovery Settings',
            subtitle: 'Set your matching preferences',
            onTap: () => Navigator.pushNamed(context, '/discovery-settings'),
          ),
          _buildSettingsTile(
            iconName: 'help',
            title: 'Help & Support',
            subtitle: 'Get help and contact support',
            onTap: () => Navigator.pushNamed(context, '/help-support'),
          ),
          _buildSettingsTile(
            iconName: 'description',
            title: 'Terms & Privacy',
            subtitle: 'Review our terms and privacy policy',
            onTap: () => _showTermsPrivacy(),
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required String iconName,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
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
                CustomIconWidget(
                  iconName: iconName,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        subtitle,
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
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

  // Action methods
  void _showEditOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            _buildBottomSheetOption(
              iconName: 'edit',
              title: 'Edit Profile',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile-creation-screen');
              },
            ),
            _buildBottomSheetOption(
              iconName: 'share',
              title: 'Share Profile',
              onTap: () {
                Navigator.pop(context);
                _shareProfile();
              },
            ),
            _buildBottomSheetOption(
              iconName: 'settings',
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings-screen');
              },
            ),
            _buildBottomSheetOption(
              iconName: 'logout',
              title: 'Sign Out',
              onTap: () {
                Navigator.pop(context);
                _showSignOutDialog();
              },
              showDivider: false,
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetOption({
    required String iconName,
    required String title,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: iconName,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 4.w),
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.5,
            color: AppTheme.lightTheme.dividerColor,
          ),
      ],
    );
  }

  void _showCompletionTips() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Profile Completion Tips'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Complete your profile to get better matches:'),
            SizedBox(height: 2.h),
            _buildTipItem(
                'Add more photos (${6 - (_userData['photos'] as List).where((p) => p != null).length} remaining)'),
            _buildTipItem('Write a compelling bio'),
            _buildTipItem('Add more interests'),
            _buildTipItem('Verify your profile'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile-creation-screen');
            },
            child: Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'circle',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6,
          ),
          SizedBox(width: 2.w),
          Expanded(child: Text(tip)),
        ],
      ),
    );
  }

  void _showVerificationInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'verified',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Profile Verified'),
          ],
        ),
        content: Text(
          'This profile has been verified. Verified profiles are more trustworthy and get better matches.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPremiumUpgrade() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Upgrade to Premium'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Unlock premium features:'),
            SizedBox(height: 2.h),
            _buildFeatureItem('Unlimited likes'),
            _buildFeatureItem('See who liked you'),
            _buildFeatureItem('5 Super Likes per day'),
            _buildFeatureItem('Boost your profile'),
            _buildFeatureItem('Advanced filters'),
            _buildFeatureItem('Read receipts'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: "Premium upgrade coming soon!",
                toastLength: Toast.LENGTH_SHORT,
              );
            },
            child: Text('Upgrade Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'check',
            color: AppTheme.lightTheme.colorScheme.tertiary,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(feature),
        ],
      ),
    );
  }

  void _showPhotoViewer(int index) {
    final photos = (_userData['photos'] as List)
        .where((p) => p != null)
        .cast<String>()
        .toList();
    if (index < photos.length) {
      Navigator.pushNamed(
        context,
        '/photo-viewer',
        arguments: {
          'photos': photos,
          'initialIndex': index,
        },
      );
    }
  }

  Future<void> _addPhoto() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // In a real app, upload the image to a server
        setState(() {
          final photos = _userData['photos'] as List;
          final emptyIndex = photos.indexWhere((p) => p == null);
          if (emptyIndex != -1) {
            photos[emptyIndex] = image.path; // Use local path temporarily
          }
        });

        Fluttertoast.showToast(
          msg: "Photo added successfully!",
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to add photo",
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  void _editPhotos() {
    Navigator.pushNamed(
      context,
      '/photo-editor',
      arguments: _userData['photos'],
    );
  }

  void _editBio() {
    showDialog(
      context: context,
      builder: (context) {
        String newBio = _userData['bio'] as String;
        return AlertDialog(
          title: Text('Edit Bio'),
          content: TextField(
            controller: TextEditingController(text: newBio),
            maxLines: 4,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: 'Tell others about yourself...',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => newBio = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => _userData['bio'] = newBio);
                Navigator.pop(context);
                Fluttertoast.showToast(
                  msg: "Bio updated successfully!",
                  toastLength: Toast.LENGTH_SHORT,
                );
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editInterests() {
    Navigator.pushNamed(
      context,
      '/interests-editor',
      arguments: _userData['interests'],
    );
  }

  void _editBasicInfo() {
    Navigator.pushNamed(
      context,
      '/basic-info-editor',
      arguments: {
        'age': _userData['age'],
        'profession': _userData['profession'],
        'location': _userData['location'],
      },
    );
  }

  void _shareProfile() {
    Fluttertoast.showToast(
      msg: "Profile sharing coming soon!",
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void _showTermsPrivacy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Terms & Privacy'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'description',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Terms of Service'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to terms
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'privacy_tip',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Privacy Policy'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to privacy policy
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign Out'),
        content: Text('Are you sure you want to sign out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login-screen',
                (route) => false,
              );
              Fluttertoast.showToast(
                msg: "Signed out successfully",
                toastLength: Toast.LENGTH_SHORT,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
