import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MatchAnimationWidget extends StatefulWidget {
  final Map<String, dynamic> matchedProfile;
  final VoidCallback? onKeepSwiping;
  final VoidCallback? onSendMessage;
  final VoidCallback? onClose;

  const MatchAnimationWidget({
    Key? key,
    required this.matchedProfile,
    this.onKeepSwiping,
    this.onSendMessage,
    this.onClose,
  }) : super(key: key);

  @override
  State<MatchAnimationWidget> createState() => _MatchAnimationWidgetState();
}

class _MatchAnimationWidgetState extends State<MatchAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.9),
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Close Button
              Positioned(
                top: 2.h,
                right: 4.w,
                child: GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),

              // Main Content
              Center(
                child: Padding(
                  padding: EdgeInsets.all(6.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Match Title with Animation
                      AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Text(
                              'It\'s a Match!',
                              style: AppTheme.lightTheme.textTheme.displaySmall
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 2.h),

                      // Subtitle
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'You and ${widget.matchedProfile['name']} liked each other',
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 6.h),

                      // Profile Images
                      AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Current User Image (placeholder)
                                Container(
                                  width: 25.w,
                                  height: 25.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: CustomImageWidget(
                                      imageUrl:
                                          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face',
                                      width: 25.w,
                                      height: 25.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                SizedBox(width: 6.w),

                                // Heart Icon
                                Container(
                                  padding: EdgeInsets.all(3.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'favorite',
                                    color: AppTheme
                                        .lightTheme.colorScheme.secondary,
                                    size: 32,
                                  ),
                                ),

                                SizedBox(width: 6.w),

                                // Matched User Image
                                Container(
                                  width: 25.w,
                                  height: 25.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: CustomImageWidget(
                                      imageUrl: widget.matchedProfile['photos']
                                              ?[0] ??
                                          '',
                                      width: 25.w,
                                      height: 25.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 8.h),

                      // Action Buttons
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            // Send Message Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: widget.onSendMessage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                  padding: EdgeInsets.symmetric(vertical: 2.h),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Send Message',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 2.h),

                            // Keep Swiping Button
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: widget.onKeepSwiping,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(
                                      color: Colors.white, width: 2),
                                  padding: EdgeInsets.symmetric(vertical: 2.h),
                                ),
                                child: Text(
                                  'Keep Swiping',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
