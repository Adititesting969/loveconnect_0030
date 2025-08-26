import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback? onFormChanged;

  const RegistrationForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    this.onFormChanged,
  });

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    widget.emailController.addListener(_validateEmail);
    widget.phoneController.addListener(_validatePhone);
    widget.passwordController.addListener(_validatePassword);
    widget.confirmPasswordController.addListener(_validateConfirmPassword);
  }

  @override
  void dispose() {
    widget.emailController.removeListener(_validateEmail);
    widget.phoneController.removeListener(_validatePhone);
    widget.passwordController.removeListener(_validatePassword);
    widget.confirmPasswordController.removeListener(_validateConfirmPassword);
    super.dispose();
  }

  void _validateEmail() {
    final email = widget.emailController.text;
    setState(() {
      if (email.isEmpty) {
        _emailError = null;
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        _emailError = 'Please enter a valid email address';
      } else {
        _emailError = null;
      }
    });
    widget.onFormChanged?.call();
  }

  void _validatePhone() {
    final phone = widget.phoneController.text;
    setState(() {
      if (phone.isEmpty) {
        _phoneError = null;
      } else if (!RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(phone)) {
        _phoneError = 'Please enter a valid phone number';
      } else {
        _phoneError = null;
      }
    });
    widget.onFormChanged?.call();
  }

  void _validatePassword() {
    final password = widget.passwordController.text;
    setState(() {
      if (password.isEmpty) {
        _passwordError = null;
      } else if (password.length < 8) {
        _passwordError = 'Password must be at least 8 characters';
      } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)')
          .hasMatch(password)) {
        _passwordError =
            'Password must contain uppercase, lowercase, and number';
      } else {
        _passwordError = null;
      }
    });
    widget.onFormChanged?.call();
  }

  void _validateConfirmPassword() {
    final confirmPassword = widget.confirmPasswordController.text;
    setState(() {
      if (confirmPassword.isEmpty) {
        _confirmPasswordError = null;
      } else if (confirmPassword != widget.passwordController.text) {
        _confirmPasswordError = 'Passwords do not match';
      } else {
        _confirmPasswordError = null;
      }
    });
    widget.onFormChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email Field
          Text(
            'Email Address *',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: widget.emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: 'Enter your email address',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'email',
                  size: 20,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              errorText: _emailError,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email address is required';
              }
              if (_emailError != null) {
                return _emailError;
              }
              return null;
            },
          ),
          SizedBox(height: 3.h),

          // Phone Field
          Text(
            'Phone Number *',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: widget.phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: 'Enter your phone number',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'phone',
                  size: 20,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              errorText: _phoneError,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone number is required';
              }
              if (_phoneError != null) {
                return _phoneError;
              }
              return null;
            },
          ),
          SizedBox(height: 3.h),

          // Password Field
          Text(
            'Password *',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: widget.passwordController,
            obscureText: !_isPasswordVisible,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: 'Create a strong password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock',
                  size: 20,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                icon: CustomIconWidget(
                  iconName:
                      _isPasswordVisible ? 'visibility_off' : 'visibility',
                  size: 20,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              errorText: _passwordError,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              if (_passwordError != null) {
                return _passwordError;
              }
              return null;
            },
          ),
          SizedBox(height: 3.h),

          // Confirm Password Field
          Text(
            'Confirm Password *',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: widget.confirmPasswordController,
            obscureText: !_isConfirmPasswordVisible,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'Confirm your password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock',
                  size: 20,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
                icon: CustomIconWidget(
                  iconName: _isConfirmPasswordVisible
                      ? 'visibility_off'
                      : 'visibility',
                  size: 20,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              errorText: _confirmPasswordError,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (_confirmPasswordError != null) {
                return _confirmPasswordError;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
