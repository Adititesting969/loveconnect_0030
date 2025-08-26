import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/match_animation_widget.dart';
import './widgets/swipe_card_widget.dart';

class DiscoverySwipeScreen extends StatefulWidget {
  const DiscoverySwipeScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverySwipeScreen> createState() => _DiscoverySwipeScreenState();
}

class _DiscoverySwipeScreenState extends State<DiscoverySwipeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> _profiles = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _showMatchAnimation = false;
  Map<String, dynamic>? _matchedProfile;

  Map<String, dynamic> _filters = {
    'minAge': 18,
    'maxAge': 35,
    'maxDistance': 50,
    'interestedIn': 'Women',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this, initialIndex: 0);
    _loadProfiles();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadProfiles() {
    setState(() {
      _isLoading = true;
    });

    // Mock profile data
    final List<Map<String, dynamic>> mockProfiles = [
      {
        "id": 1,
        "name": "Emma",
        "age": 28,
        "distance": 3,
        "bio":
            "Adventure seeker, coffee lover, and dog mom. Looking for someone to explore the city with!",
        "photos": [
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=600&fit=crop&crop=face",
          "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400&h=600&fit=crop&crop=face"
        ],
        "verified": true,
        "interests": ["Travel", "Photography", "Hiking"]
      },
      {
        "id": 2,
        "name": "Sophia",
        "age": 25,
        "distance": 7,
        "bio":
            "Yoga instructor and wellness enthusiast. Let's find balance together ✨",
        "photos": [
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=600&fit=crop&crop=face",
          "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&h=600&fit=crop&crop=face"
        ],
        "verified": false,
        "interests": ["Yoga", "Meditation", "Healthy Living"]
      },
      {
        "id": 3,
        "name": "Isabella",
        "age": 30,
        "distance": 12,
        "bio":
            "Artist and creative soul. I paint emotions and capture moments. What's your story?",
        "photos": [
          "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&h=600&fit=crop&crop=face",
          "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400&h=600&fit=crop&crop=face"
        ],
        "verified": true,
        "interests": ["Art", "Museums", "Creative Writing"]
      },
      {
        "id": 4,
        "name": "Olivia",
        "age": 27,
        "distance": 5,
        "bio":
            "Foodie, traveler, and spontaneous adventurer. Life's too short for boring conversations!",
        "photos": [
          "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400&h=600&fit=crop&crop=face",
          "https://images.unsplash.com/photo-1506863530036-1efeddceb993?w=400&h=600&fit=crop&crop=face"
        ],
        "verified": false,
        "interests": ["Food", "Travel", "Dancing"]
      },
      {
        "id": 5,
        "name": "Ava",
        "age": 26,
        "distance": 8,
        "bio":
            "Marketing professional by day, salsa dancer by night. Looking for my dance partner in life!",
        "photos": [
          "https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400&h=600&fit=crop&crop=face",
          "https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=400&h=600&fit=crop&crop=face"
        ],
        "verified": true,
        "interests": ["Dancing", "Music", "Networking"]
      }
    ];

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _profiles = mockProfiles;
        _currentIndex = 0;
        _isLoading = false;
      });
    });
  }

  void _handleLike() {
    if (_currentIndex < _profiles.length) {
      // Simulate match (30% chance)
      final isMatch = DateTime.now().millisecond % 10 < 3;

      if (isMatch) {
        setState(() {
          _matchedProfile = _profiles[_currentIndex];
          _showMatchAnimation = true;
        });
      } else {
        _nextProfile();
      }
    }
  }

  void _handlePass() {
    _nextProfile();
  }

  void _handleSuperLike() {
    // Super like always results in a match for demo purposes
    if (_currentIndex < _profiles.length) {
      setState(() {
        _matchedProfile = _profiles[_currentIndex];
        _showMatchAnimation = true;
      });
    }
  }

  void _nextProfile() {
    setState(() {
      _currentIndex++;
    });
  }

  void _openProfileDetail() {
    if (_currentIndex < _profiles.length) {
      Navigator.pushNamed(
        context,
        '/profile-detail-modal',
        arguments: _profiles[_currentIndex],
      );
    }
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _filters,
        onFiltersChanged: (newFilters) {
          setState(() {
            _filters = newFilters;
          });
          _loadProfiles();
        },
      ),
    );
  }

  void _closeMatchAnimation() {
    setState(() {
      _showMatchAnimation = false;
      _matchedProfile = null;
    });
    _nextProfile();
  }

  void _sendMessage() {
    Navigator.pushNamed(
      context,
      '/chat-messaging-screen',
      arguments: _matchedProfile,
    );
  }

  void _keepSwiping() {
    _closeMatchAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo/Title
                      Row(
                        children: [
                          Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.lightTheme.colorScheme.secondary,
                                  AppTheme.lightTheme.colorScheme.tertiary,
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: 'favorite',
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            'LoveConnect',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),

                      // Action Icons
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _openFilters,
                            child: Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme
                                    .surfaceContainerHighest,
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: 'tune',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, '/settings-screen'),
                            child: Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme
                                    .surfaceContainerHighest,
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: 'settings',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Tab Bar
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(
                        icon: CustomIconWidget(
                          iconName: 'explore',
                          color: _tabController.index == 0
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        text: 'Discover',
                      ),
                      Tab(
                        icon: CustomIconWidget(
                          iconName: 'favorite',
                          color: _tabController.index == 1
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        text: 'Matches',
                      ),
                      Tab(
                        icon: CustomIconWidget(
                          iconName: 'chat',
                          color: _tabController.index == 2
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        text: 'Messages',
                      ),
                      Tab(
                        icon: CustomIconWidget(
                          iconName: 'star',
                          color: _tabController.index == 3
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        text: 'Likes',
                      ),
                      Tab(
                        icon: CustomIconWidget(
                          iconName: 'person',
                          color: _tabController.index == 4
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        text: 'Profile',
                      ),
                    ],
                    indicator: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor:
                        AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    labelStyle:
                        AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle:
                        AppTheme.lightTheme.textTheme.labelSmall,
                    onTap: (index) {
                      switch (index) {
                        case 1:
                          Navigator.pushNamed(context, '/matches-screen');
                          break;
                        case 2:
                          Navigator.pushNamed(
                              context, '/chat-messaging-screen');
                          break;
                        case 4:
                          Navigator.pushNamed(context, '/user-profile-screen');
                          break;
                      }
                    },
                  ),
                ),

                SizedBox(height: 2.h),

                // Main Content Area
                Expanded(
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        )
                      : _currentIndex >= _profiles.length
                          ? EmptyStateWidget(
                              onRefresh: _loadProfiles,
                              onAdjustFilters: _openFilters,
                            )
                          : Center(
                              child: SwipeCardWidget(
                                profile: _profiles[_currentIndex],
                                onLike: _handleLike,
                                onPass: _handlePass,
                                onTap: _openProfileDetail,
                              ),
                            ),
                ),

                // Action Buttons
                if (!_isLoading && _currentIndex < _profiles.length)
                  ActionButtonsWidget(
                    onPass: _handlePass,
                    onSuperLike: _handleSuperLike,
                    onLike: _handleLike,
                  ),

                SizedBox(height: 2.h),
              ],
            ),
          ),

          // Match Animation Overlay
          if (_showMatchAnimation && _matchedProfile != null)
            MatchAnimationWidget(
              matchedProfile: _matchedProfile!,
              onKeepSwiping: _keepSwiping,
              onSendMessage: _sendMessage,
              onClose: _closeMatchAnimation,
            ),
        ],
      ),
    );
  }
}
