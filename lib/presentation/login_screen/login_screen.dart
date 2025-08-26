import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/login_form_widget.dart';
import './widgets/login_header_widget.dart';
import './widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  // Mock credentials for testing
  final Map<String, String> _mockCredentials = {
    'admin@loveconnect.com': 'admin123',
    'user@loveconnect.com': 'user123',
    'demo@loveconnect.com': 'demo123',
  };

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _emailController.text.contains('@') &&
        _passwordController.text.length >= 6;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Check mock credentials
    if (_mockCredentials.containsKey(email) &&
        _mockCredentials[email] == password) {
      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      setState(() {
        _isLoading = false;
      });

      // Navigate to discovery screen
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/discovery-swipe-screen');
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Invalid email or password. Please try again.';
      });
    }
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Reset Password',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Password reset functionality will be available soon. Please contact support for assistance.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleSocialLogin(String provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '$provider Login',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          '$provider authentication will be available soon.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _navigateToSignUp() {
    Navigator.pushNamed(context, '/registration-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 4.h),

                // Header with logo and welcome text
                const LoginHeaderWidget(),
                SizedBox(height: 4.h),

                // Login Form
                LoginFormWidget(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  formKey: _formKey,
                  onForgotPassword: _handleForgotPassword,
                  isLoading: _isLoading,
                ),
                SizedBox(height: 3.h),

                // Error Message
                if (_errorMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.error
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'error',
                          size: 20,
                          color: AppTheme.lightTheme.colorScheme.error,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed:
                        _isLoading || !_isFormValid ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
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
                            'Login',
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 4.h),

                // Social Login Options
                SocialLoginWidget(
                  onGoogleLogin: () => _handleSocialLogin('Google'),
                  onAppleLogin: () => _handleSocialLogin('Apple'),
                  onFacebookLogin: () => _handleSocialLogin('Facebook'),
                ),
                SizedBox(height: 4.h),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New user? ',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    GestureDetector(
                      onTap: _isLoading ? null : _navigateToSignUp,
                      child: Text(
                        'Sign Up',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
