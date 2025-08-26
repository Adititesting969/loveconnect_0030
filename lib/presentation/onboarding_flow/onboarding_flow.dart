import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/onboarding_button_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';
import './widgets/privacy_terms_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _privacyAccepted = false;
  bool _termsAccepted = false;

  // Mock onboarding data
  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Find Your Perfect Match",
      "description":
          "Discover meaningful connections with people who share your interests and values. Our smart matching algorithm helps you find compatible partners.",
      "image":
          "https://images.pexels.com/photos/3184291/pexels-photo-3184291.jpeg?auto=compress&cs=tinysrgb&w=800",
    },
    {
      "title": "Swipe to Connect",
      "description":
          "Simple and intuitive swiping interface. Swipe right to like, left to pass. When you both swipe right, it's a match!",
      "image":
          "https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?auto=format&fit=crop&w=800&q=80",
    },
    {
      "title": "Chat & Get to Know",
      "description":
          "Start meaningful conversations with your matches. Share photos, voice messages, and plan your first date together.",
      "image":
          "https://images.pixabay.com/photo/2020/05/18/16/17/social-media-5187243_960_720.png",
    },
    {
      "title": "Stay Safe & Secure",
      "description":
          "Your safety is our priority. Report inappropriate behavior, block unwanted contacts, and enjoy verified profiles for peace of mind.",
      "image":
          "https://images.pexels.com/photos/60504/security-protection-anti-virus-software-60504.jpeg?auto=compress&cs=tinysrgb&w=800",
    },
    {
      "title": "Ready to Find Love?",
      "description":
          "Join thousands of singles who have found meaningful relationships through LoveConnect. Your perfect match is just a swipe away!",
      "image":
          "https://images.unsplash.com/photo-1522621032211-ac0031dfbddc?auto=format&fit=crop&w=800&q=80",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToRegistration();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      HapticFeedback.lightImpact();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/registration-screen');
  }

  void _navigateToRegistration() {
    if (_currentPage == _onboardingData.length - 1) {
      if (_privacyAccepted && _termsAccepted) {
        HapticFeedback.mediumImpact();
        Navigator.pushReplacementNamed(context, '/registration-screen');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please accept Privacy Policy and Terms of Service to continue',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.all(4.w),
          ),
        );
      }
    } else {
      HapticFeedback.mediumImpact();
      Navigator.pushReplacementNamed(context, '/registration-screen');
    }
  }

  bool get _canProceed {
    return _currentPage < _onboardingData.length - 1 ||
        (_privacyAccepted && _termsAccepted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: Column(
        children: [
          // Skip Button
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button (only show if not on first page)
                  _currentPage > 0
                      ? GestureDetector(
                          onTap: _previousPage,
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppTheme.lightTheme.colorScheme.outline,
                                width: 1,
                              ),
                            ),
                            child: CustomIconWidget(
                              iconName: 'arrow_back',
                              size: 20,
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                        )
                      : SizedBox(width: 10.w),

                  // Skip Button
                  OnboardingButtonWidget(
                    text: 'Skip',
                    onPressed: _skipOnboarding,
                    isPrimary: false,
                  ),
                ],
              ),
            ),
          ),

          // PageView Content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                HapticFeedback.selectionClick();
              },
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) {
                final data = _onboardingData[index];
                return OnboardingPageWidget(
                  imagePath: data["image"] as String,
                  title: data["title"] as String,
                  description: data["description"] as String,
                  isLastPage: index == _onboardingData.length - 1,
                );
              },
            ),
          ),

          // Bottom Section
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              child: Column(
                children: [
                  // Privacy and Terms (only on last page)
                  if (_currentPage == _onboardingData.length - 1) ...[
                    PrivacyTermsWidget(
                      privacyAccepted: _privacyAccepted,
                      termsAccepted: _termsAccepted,
                      onPrivacyChanged: (value) {
                        setState(() {
                          _privacyAccepted = value;
                        });
                      },
                      onTermsChanged: (value) {
                        setState(() {
                          _termsAccepted = value;
                        });
                      },
                    ),
                    SizedBox(height: 3.h),
                  ],

                  // Page Indicator
                  PageIndicatorWidget(
                    currentPage: _currentPage,
                    totalPages: _onboardingData.length,
                  ),

                  SizedBox(height: 3.h),

                  // Action Button
                  OnboardingButtonWidget(
                    text: _currentPage == _onboardingData.length - 1
                        ? 'Get Started'
                        : 'Next',
                    onPressed: _canProceed
                        ? _nextPage
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please accept Privacy Policy and Terms of Service to continue',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary,
                                  ),
                                ),
                                backgroundColor:
                                    AppTheme.lightTheme.colorScheme.error,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: EdgeInsets.all(4.w),
                              ),
                            );
                          },
                    isPrimary: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
