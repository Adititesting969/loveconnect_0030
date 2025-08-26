import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/basic_info_widget.dart';
import './widgets/bio_widget.dart';
import './widgets/interests_widget.dart';
import './widgets/photo_upload_widget.dart';
import './widgets/progress_indicator_widget.dart';

class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({Key? key}) : super(key: key);

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // State variables
  XFile? _selectedPhoto;
  List<String> _selectedInterests = [];
  int _currentPage = 0;
  bool _isDraftSaved = false;
  late AnimationController _celebrationController;
  late Animation<double> _celebrationAnimation;

  // Progress tracking
  final int _totalSteps = 4;

  @override
  void initState() {
    super.initState();
    _loadDraft();
    _setupCelebrationAnimation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    _pageController.dispose();
    _celebrationController.dispose();
    super.dispose();
  }

  void _setupCelebrationAnimation() {
    _celebrationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _celebrationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _celebrationController,
      curve: Curves.elasticOut,
    ));
  }

  void _loadDraft() {
    // In a real app, load from SharedPreferences
    // For now, we'll use mock data to demonstrate
    setState(() {
      _isDraftSaved = false;
    });
  }

  void _saveDraft() {
    // In a real app, save to SharedPreferences
    setState(() {
      _isDraftSaved = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Draft saved successfully'),
        backgroundColor: AppTheme.successLight,
        duration: Duration(seconds: 2),
      ),
    );
  }

  double _calculateProgress() {
    double progress = 0.0;

    // Photo (25%)
    if (_selectedPhoto != null) progress += 0.25;

    // Basic info (25%)
    if (_nameController.text.isNotEmpty &&
        _ageController.text.isNotEmpty &&
        _locationController.text.isNotEmpty) {
      progress += 0.25;
    }

    // Bio (25%)
    if (_bioController.text.length >= 20) progress += 0.25;

    // Interests (25%)
    if (_selectedInterests.length >= 3) progress += 0.25;

    return progress;
  }

  bool _canProceedToNext() {
    switch (_currentPage) {
      case 0: // Photo
        return _selectedPhoto != null;
      case 1: // Basic info
        return _nameController.text.isNotEmpty &&
            _ageController.text.isNotEmpty &&
            _locationController.text.isNotEmpty;
      case 2: // Bio
        return _bioController.text.length >= 20;
      case 3: // Interests
        return _selectedInterests.length >= 3;
      default:
        return false;
    }
  }

  void _nextPage() {
    if (_canProceedToNext()) {
      if (_currentPage < _totalSteps - 1) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _completeProfile();
      }
    } else {
      _showValidationMessage();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showValidationMessage() {
    String message = '';
    switch (_currentPage) {
      case 0:
        message = 'Please add a profile photo to continue';
        break;
      case 1:
        message = 'Please fill in all basic information fields';
        break;
      case 2:
        message = 'Please write at least 20 characters about yourself';
        break;
      case 3:
        message = 'Please select at least 3 interests';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.warningLight,
      ),
    );
  }

  void _completeProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      _celebrationController.forward();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile created successfully! 🎉'),
          backgroundColor: AppTheme.successLight,
          duration: Duration(seconds: 3),
        ),
      );

      // Navigate to discovery screen after animation
      Future.delayed(Duration(milliseconds: 2000), () {
        Navigator.pushReplacementNamed(context, '/discovery-swipe-screen');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Create Profile'),
        leading: _currentPage > 0
            ? IconButton(
                onPressed: _previousPage,
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              )
            : IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
        actions: [
          TextButton(
            onPressed: _saveDraft,
            child: Text(
              'Save Draft',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              ProgressIndicatorWidget(
                progress: _calculateProgress(),
                currentStep: _currentPage + 1,
                totalSteps: _totalSteps,
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      // Page 1: Photo Upload
                      _buildPhotoPage(),

                      // Page 2: Basic Information
                      _buildBasicInfoPage(),

                      // Page 3: Bio
                      _buildBioPage(),

                      // Page 4: Interests
                      _buildInterestsPage(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Celebration overlay
          AnimatedBuilder(
            animation: _celebrationAnimation,
            builder: (context, child) {
              return _celebrationAnimation.value > 0
                  ? Container(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.9 * _celebrationAnimation.value),
                      child: Center(
                        child: Transform.scale(
                          scale: _celebrationAnimation.value,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'celebration',
                                color: Colors.white,
                                size: 80,
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                'Profile Complete!',
                                style: AppTheme
                                    .lightTheme.textTheme.headlineMedium
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Welcome to LoveConnect',
                                style: AppTheme.lightTheme.textTheme.bodyLarge
                                    ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink();
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (_currentPage > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousPage,
                  child: Text('Back'),
                ),
              ),
            if (_currentPage > 0) SizedBox(width: 4.w),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _nextPage,
                child: Text(
                  _currentPage == _totalSteps - 1
                      ? 'Complete Profile'
                      : 'Continue',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          SizedBox(height: 4.h),
          Text(
            'Add Your Best Photo',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            'Choose a photo that shows your personality and makes you feel confident',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          Center(
            child: PhotoUploadWidget(
              selectedPhoto: _selectedPhoto,
              onPhotoSelected: (photo) {
                setState(() {
                  _selectedPhoto = photo;
                });
              },
            ),
          ),
          SizedBox(height: 4.h),
          if (_selectedPhoto != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.successLight,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Great choice! You can always change this later.',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.successLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBasicInfoPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          Text(
            'Tell Us About Yourself',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            'Help others get to know the basics about you',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          BasicInfoWidget(
            nameController: _nameController,
            ageController: _ageController,
            locationController: _locationController,
            onLocationChanged: (location) {
              // Handle location changes if needed
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBioPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          Text(
            'Share Your Story',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            'Write something that captures who you are and what makes you unique',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          BioWidget(
            bioController: _bioController,
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          Text(
            'What Are You Into?',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            'Select interests that represent you and help you connect with like-minded people',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          InterestsWidget(
            selectedInterests: _selectedInterests,
            onInterestsChanged: (interests) {
              setState(() {
                _selectedInterests = interests;
              });
            },
          ),
        ],
      ),
    );
  }
}
