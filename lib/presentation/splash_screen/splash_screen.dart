import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _loadingAnimation;

  bool _showRetryButton = false;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Loading animation controller
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Loading animation
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start logo animation
    _logoAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate app initialization tasks
      await Future.wait([
        _checkAuthenticationStatus(),
        _loadUserPreferences(),
        _requestLocationPermissions(),
        _prepareCachedData(),
        Future.delayed(const Duration(seconds: 2)), // Minimum splash duration
      ]);

      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        _handleInitializationError();
      }
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    // Simulate authentication check
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _loadUserPreferences() async {
    // Simulate loading user preferences
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _requestLocationPermissions() async {
    // Simulate location permission request
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<void> _prepareCachedData() async {
    // Simulate preparing cached profile data
    await Future.delayed(const Duration(milliseconds: 600));
  }

  void _navigateToNextScreen() {
    // Mock authentication status - in real app, this would check actual auth state
    final bool isAuthenticated = false; // Mock value
    final bool isFirstTime = true; // Mock value

    String nextRoute;
    if (isAuthenticated) {
      nextRoute = '/discovery-swipe-screen';
    } else if (isFirstTime) {
      nextRoute = '/onboarding-flow';
    } else {
      nextRoute = '/login-screen';
    }

    Navigator.pushReplacementNamed(context, nextRoute);
  }

  void _handleInitializationError() {
    setState(() {
      _isInitializing = false;
      _showRetryButton = true;
    });

    // Auto-retry after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _showRetryButton) {
        _retryInitialization();
      }
    });
  }

  void _retryInitialization() {
    setState(() {
      _showRetryButton = false;
      _isInitializing = true;
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.colorScheme.secondary,
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.8),
              AppTheme.lightTheme.colorScheme.tertiary,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo section
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _logoAnimationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _logoFadeAnimation,
                        child: ScaleTransition(
                          scale: _logoScaleAnimation,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Heart icon as logo
                              Container(
                                width: 25.w,
                                height: 25.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: CustomIconWidget(
                                    iconName: 'favorite',
                                    color: AppTheme
                                        .lightTheme.colorScheme.secondary,
                                    size: 12.w,
                                  ),
                                ),
                              ),
                              SizedBox(height: 3.h),
                              // App name
                              Text(
                                'LoveConnect',
                                style: AppTheme
                                    .lightTheme.textTheme.headlineLarge
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              // Tagline
                              Text(
                                'Find Your Perfect Match',
                                style: AppTheme.lightTheme.textTheme.bodyLarge
                                    ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Loading section
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _isInitializing
                        ? _buildLoadingIndicator()
                        : _buildRetrySection(),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _loadingAnimation,
          builder: (context, child) {
            return Container(
              width: 8.w,
              height: 8.w,
              child: CircularProgressIndicator(
                value: null,
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withValues(alpha: 0.8),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 2.h),
        Text(
          'Preparing your experience...',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildRetrySection() {
    return Column(
      children: [
        CustomIconWidget(
          iconName: 'error_outline',
          color: Colors.white.withValues(alpha: 0.8),
          size: 8.w,
        ),
        SizedBox(height: 2.h),
        Text(
          'Connection timeout',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Please check your internet connection',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(height: 3.h),
        ElevatedButton(
          onPressed: _retryInitialization,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.lightTheme.colorScheme.secondary,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Text(
            'Retry',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
