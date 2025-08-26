import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/registration_form.dart';
import './widgets/social_login_buttons.dart';
import './widgets/terms_privacy_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isTermsAgreed = false;
  bool _isFormValid = false;

  // Mock user data for demonstration
  final List<Map<String, dynamic>> existingUsers = [
    {
      "email": "john.doe@example.com",
      "phone": "+1234567890",
      "password": "Password123",
    },
    {
      "email": "sarah.wilson@example.com",
      "phone": "+1987654321",
      "password": "SecurePass456",
    },
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final isEmailValid = _emailController.text.isNotEmpty &&
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
            .hasMatch(_emailController.text);
    final isPhoneValid = _phoneController.text.isNotEmpty &&
        RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(_phoneController.text);
    final isPasswordValid = _passwordController.text.length >= 8 &&
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)')
            .hasMatch(_passwordController.text);
    final isConfirmPasswordValid =
        _confirmPasswordController.text == _passwordController.text;

    setState(() {
      _isFormValid = isEmailValid &&
          isPhoneValid &&
          isPasswordValid &&
          isConfirmPasswordValid &&
          _isTermsAgreed;
    });
  }

  Future<void> _handleSocialLogin(String provider) async {
    setState(() => _isLoading = true);

    try {
      // Simulate social login API call
      await Future.delayed(const Duration(seconds: 2));

      // Simulate successful social login
      HapticFeedback.lightImpact();
      Fluttertoast.showToast(
        msg: "Successfully signed in with $provider",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/profile-creation-screen');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to sign in with $provider. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate() || !_isTermsAgreed) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Check if email already exists
      final emailExists = (existingUsers as List).any((dynamic user) =>
          (user as Map<String, dynamic>)["email"] == _emailController.text);

      if (emailExists) {
        Fluttertoast.showToast(
          msg: "An account with this email already exists",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        return;
      }

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 3));

      // Simulate successful registration
      HapticFeedback.lightImpact();
      Fluttertoast.showToast(
        msg: "Account created successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/profile-creation-screen');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Network error. Please check your connection and try again.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showTermsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 12.w,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Terms of Service',
                style: AppTheme.lightTheme.textTheme.headlineSmall,
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Text(
                    'Welcome to LoveConnect. By using our service, you agree to these terms...\n\nPlease read these terms carefully before using our dating application.',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacyModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 12.w,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Privacy Policy',
                style: AppTheme.lightTheme.textTheme.headlineSmall,
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Text(
                    'Your privacy is important to us. This policy explains how we collect, use, and protect your personal information...\n\nWe are committed to protecting your personal data and respecting your privacy rights.',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and progress
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'arrow_back',
                      size: 24,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: ProgressIndicatorWidget(
                      currentStep: 1,
                      totalSteps: 3,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),

                    // Title and subtitle
                    Text(
                      'Create Your Account',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Join LoveConnect to start meeting amazing people near you',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Social login buttons
                    SocialLoginButtons(
                      onGooglePressed: _isLoading
                          ? null
                          : () => _handleSocialLogin('Google'),
                      onApplePressed:
                          _isLoading ? null : () => _handleSocialLogin('Apple'),
                      onFacebookPressed: _isLoading
                          ? null
                          : () => _handleSocialLogin('Facebook'),
                    ),
                    SizedBox(height: 4.h),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: AppTheme.lightTheme.colorScheme.outline,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(
                            'or',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: AppTheme.lightTheme.colorScheme.outline,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // Registration form
                    RegistrationForm(
                      formKey: _formKey,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      onFormChanged: _validateForm,
                    ),
                    SizedBox(height: 3.h),

                    // Terms and privacy agreement
                    TermsPrivacyWidget(
                      isAgreed: _isTermsAgreed,
                      onChanged: (value) {
                        setState(() {
                          _isTermsAgreed = value ?? false;
                        });
                        _validateForm();
                      },
                      onTermsPressed: _showTermsModal,
                      onPrivacyPressed: _showPrivacyModal,
                    ),
                    SizedBox(height: 4.h),

                    // Continue button
                    SizedBox(
                      width: double.infinity,
                      height: 6.h,
                      child: ElevatedButton(
                        onPressed: _isFormValid && !_isLoading
                            ? _handleRegistration
                            : null,
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                  ),
                                ),
                              )
                            : Text(
                                'Continue',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Login link
                    Center(
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, '/login-screen'),
                        child: RichText(
                          text: TextSpan(
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            children: [
                              const TextSpan(text: 'Already have an account? '),
                              TextSpan(
                                text: 'Login',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
