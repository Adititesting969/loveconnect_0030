import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/premium_banner_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/settings_slider_widget.dart';
import './widgets/settings_toggle_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Privacy Settings
  bool _profileVisible = true;
  bool _locationSharing = true;
  bool _readReceipts = true;
  bool _onlineStatus = false;

  // Notification Settings
  bool _newMatches = true;
  bool _messages = true;
  bool _likes = true;
  bool _promotionalContent = false;

  // Discovery Settings
  double _ageRangeMin = 22;
  double _ageRangeMax = 35;
  double _distanceRadius = 25;

  // User data
  final Map<String, dynamic> _userData = {
    "name": "Sarah Johnson",
    "email": "sarah.johnson@email.com",
    "phone": "+1 (555) 123-4567",
    "isPremium": false,
    "isVerified": true,
    "joinDate": "March 2024",
    "profileCompletion": 85,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 1.h),
            if (!(_userData["isPremium"] as bool)) _buildPremiumBanner(),
            _buildAccountSection(),
            _buildPrivacySection(),
            _buildNotificationSection(),
            _buildDiscoverySection(),
            _buildSupportSection(),
            _buildDangerZoneSection(),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      title: Text(
        'Settings',
        style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: _showSearchDialog,
          icon: CustomIconWidget(
            iconName: 'search',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumBanner() {
    return PremiumBannerWidget(
      onUpgradeTap: () {
        Fluttertoast.showToast(
          msg: "Premium upgrade feature coming soon!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      },
    );
  }

  Widget _buildAccountSection() {
    return SettingsSectionWidget(
      title: 'Account',
      children: [
        SettingsItemWidget(
          iconName: 'person',
          title: 'Edit Profile',
          subtitle: 'Update your photos and information',
          onTap: () => Navigator.pushNamed(context, '/profile-creation-screen'),
        ),
        SettingsItemWidget(
          iconName: 'verified',
          title: 'Verification',
          subtitle: (_userData["isVerified"] as bool)
              ? 'Profile verified ✓'
              : 'Verify your profile for more matches',
          trailing: (_userData["isVerified"] as bool)
              ? CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 20,
                )
              : null,
          onTap: () => _showVerificationDialog(),
        ),
        SettingsItemWidget(
          iconName: 'star',
          title: 'Subscription',
          subtitle: (_userData["isPremium"] as bool)
              ? 'Premium Active'
              : 'Upgrade to Premium',
          onTap: () => _showSubscriptionDialog(),
        ),
        SettingsItemWidget(
          iconName: 'payment',
          title: 'Payment Methods',
          subtitle: 'Manage your payment options',
          onTap: () => _showPaymentMethodsDialog(),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildPrivacySection() {
    return SettingsSectionWidget(
      title: 'Privacy & Safety',
      children: [
        SettingsToggleWidget(
          iconName: 'visibility',
          title: 'Profile Visibility',
          subtitle: 'Show your profile to other users',
          value: _profileVisible,
          onChanged: (value) => setState(() => _profileVisible = value),
        ),
        SettingsToggleWidget(
          iconName: 'location_on',
          title: 'Location Sharing',
          subtitle: 'Allow others to see your distance',
          value: _locationSharing,
          onChanged: (value) => setState(() => _locationSharing = value),
        ),
        SettingsToggleWidget(
          iconName: 'done_all',
          title: 'Read Receipts',
          subtitle: 'Let others know when you\'ve read their messages',
          value: _readReceipts,
          onChanged: (value) => setState(() => _readReceipts = value),
        ),
        SettingsToggleWidget(
          iconName: 'circle',
          title: 'Online Status',
          subtitle: 'Show when you\'re active on the app',
          value: _onlineStatus,
          onChanged: (value) => setState(() => _onlineStatus = value),
        ),
        SettingsItemWidget(
          iconName: 'block',
          title: 'Blocked Users',
          subtitle: 'Manage blocked profiles',
          onTap: () => _showBlockedUsersDialog(),
        ),
        SettingsItemWidget(
          iconName: 'security',
          title: 'Privacy Settings',
          subtitle: 'Advanced privacy controls',
          onTap: () => _showPrivacySettingsDialog(),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildNotificationSection() {
    return SettingsSectionWidget(
      title: 'Notifications',
      children: [
        SettingsToggleWidget(
          iconName: 'favorite',
          title: 'New Matches',
          subtitle: 'Get notified when you have a new match',
          value: _newMatches,
          onChanged: (value) => setState(() => _newMatches = value),
        ),
        SettingsToggleWidget(
          iconName: 'message',
          title: 'Messages',
          subtitle: 'Get notified about new messages',
          value: _messages,
          onChanged: (value) => setState(() => _messages = value),
        ),
        SettingsToggleWidget(
          iconName: 'thumb_up',
          title: 'Likes',
          subtitle: 'Get notified when someone likes you',
          value: _likes,
          onChanged: (value) => setState(() => _likes = value),
        ),
        SettingsToggleWidget(
          iconName: 'campaign',
          title: 'Promotional Content',
          subtitle: 'Receive updates about new features and offers',
          value: _promotionalContent,
          onChanged: (value) => setState(() => _promotionalContent = value),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildDiscoverySection() {
    return SettingsSectionWidget(
      title: 'Discovery Preferences',
      children: [
        SettingsSliderWidget(
          iconName: 'cake',
          title: 'Age Range',
          value: _ageRangeMax,
          min: 18,
          max: 65,
          divisions: 47,
          valueFormatter: (value) => '${_ageRangeMin.round()}-${value.round()}',
          onChanged: (value) => setState(() => _ageRangeMax = value),
        ),
        SettingsSliderWidget(
          iconName: 'location_on',
          title: 'Distance',
          value: _distanceRadius,
          min: 1,
          max: 100,
          divisions: 99,
          valueFormatter: (value) => '${value.round()} km',
          onChanged: (value) => setState(() => _distanceRadius = value),
        ),
        SettingsItemWidget(
          iconName: 'tune',
          title: 'Advanced Filters',
          subtitle: 'Set deal-breakers and preferences',
          onTap: () => _showAdvancedFiltersDialog(),
        ),
        SettingsItemWidget(
          iconName: 'refresh',
          title: 'Reset Preferences',
          subtitle: 'Start fresh with discovery settings',
          onTap: () => _showResetPreferencesDialog(),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return SettingsSectionWidget(
      title: 'Support & Legal',
      children: [
        SettingsItemWidget(
          iconName: 'help',
          title: 'Help Center',
          subtitle: 'Find answers to common questions',
          onTap: () => _showHelpCenterDialog(),
        ),
        SettingsItemWidget(
          iconName: 'contact_support',
          title: 'Contact Us',
          subtitle: 'Get in touch with our support team',
          onTap: () => _showContactSupportDialog(),
        ),
        SettingsItemWidget(
          iconName: 'gavel',
          title: 'Community Guidelines',
          subtitle: 'Learn about our community standards',
          onTap: () => _showCommunityGuidelinesDialog(),
        ),
        SettingsItemWidget(
          iconName: 'privacy_tip',
          title: 'Privacy Policy',
          subtitle: 'How we protect your information',
          onTap: () => _showPrivacyPolicyDialog(),
        ),
        SettingsItemWidget(
          iconName: 'description',
          title: 'Terms of Service',
          subtitle: 'Our terms and conditions',
          onTap: () => _showTermsOfServiceDialog(),
        ),
        SettingsItemWidget(
          iconName: 'info',
          title: 'About LoveConnect',
          subtitle: 'Version 2.1.0 • Build 2024.08.26',
          onTap: () => _showAboutDialog(),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildDangerZoneSection() {
    return SettingsSectionWidget(
      title: 'Danger Zone',
      children: [
        SettingsItemWidget(
          iconName: 'logout',
          title: 'Sign Out',
          subtitle: 'Sign out of your account',
          onTap: () => _showSignOutDialog(),
        ),
        SettingsItemWidget(
          iconName: 'delete_forever',
          title: 'Delete Account',
          subtitle: 'Permanently delete your account and data',
          onTap: () => _showDeleteAccountDialog(),
          showDivider: false,
        ),
      ],
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search Settings'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Search for a setting...',
            prefixIcon: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          onChanged: (value) {
            // Implement search functionality
          },
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

  void _showVerificationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Profile Verification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'verified',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              (_userData["isVerified"] as bool)
                  ? 'Your profile is already verified!'
                  : 'Verify your profile to increase trust and get more matches.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          if (!(_userData["isVerified"] as bool))
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Fluttertoast.showToast(
                  msg: "Verification process started!",
                  toastLength: Toast.LENGTH_SHORT,
                );
              },
              child: Text('Start Verification'),
            ),
        ],
      ),
    );
  }

  void _showSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Subscription'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Premium Features:'),
            SizedBox(height: 1.h),
            _buildFeatureItem('Unlimited likes'),
            _buildFeatureItem('See who liked you'),
            _buildFeatureItem('Super likes'),
            _buildFeatureItem('Boost your profile'),
            _buildFeatureItem('Advanced filters'),
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
              Fluttertoast.showToast(
                msg: "Subscription upgrade coming soon!",
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

  void _showPaymentMethodsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Methods'),
        content: Text('Manage your payment methods and billing information.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: "Payment methods feature coming soon!",
                toastLength: Toast.LENGTH_SHORT,
              );
            },
            child: Text('Add Payment Method'),
          ),
        ],
      ),
    );
  }

  void _showBlockedUsersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Blocked Users'),
        content: Text('You haven\'t blocked any users yet.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacySettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Advanced Privacy'),
        content: Text('Configure advanced privacy and safety settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAdvancedFiltersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Advanced Filters'),
        content: Text(
            'Set specific preferences and deal-breakers for better matches.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showResetPreferencesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Preferences'),
        content: Text(
            'Are you sure you want to reset all discovery preferences to default?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _ageRangeMin = 22;
                _ageRangeMax = 35;
                _distanceRadius = 25;
              });
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: "Preferences reset to default!",
                toastLength: Toast.LENGTH_SHORT,
              );
            },
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showHelpCenterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Help Center'),
        content:
            Text('Browse our help articles and frequently asked questions.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showContactSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Need help? Get in touch with our support team:'),
            SizedBox(height: 2.h),
            Text('Email: support@loveconnect.com'),
            Text('Phone: 1-800-LOVE-HELP'),
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
              Fluttertoast.showToast(
                msg: "Opening email client...",
                toastLength: Toast.LENGTH_SHORT,
              );
            },
            child: Text('Send Email'),
          ),
        ],
      ),
    );
  }

  void _showCommunityGuidelinesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Community Guidelines'),
        content: Text(
            'Learn about our community standards and what behavior is expected on LoveConnect.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy Policy'),
        content: Text(
            'Read our privacy policy to understand how we collect, use, and protect your data.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Terms of Service'),
        content: Text('Review our terms and conditions for using LoveConnect.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About LoveConnect'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'favorite',
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text('LoveConnect'),
            Text('Version 2.1.0'),
            Text('Build 2024.08.26'),
            SizedBox(height: 1.h),
            Text('Connecting hearts, one match at a time.'),
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
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'This action cannot be undone. All your data, matches, and conversations will be permanently deleted.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showFinalDeleteConfirmation();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  void _showFinalDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Final Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Type "DELETE" to confirm account deletion:'),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                hintText: 'Type DELETE here',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Handle confirmation text
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: "Account deletion feature coming soon",
                toastLength: Toast.LENGTH_SHORT,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Confirm Delete'),
          ),
        ],
      ),
    );
  }
}
