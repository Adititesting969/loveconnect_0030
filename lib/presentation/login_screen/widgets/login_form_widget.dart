import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginFormWidget extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final VoidCallback? onForgotPassword;
  final bool isLoading;

  const LoginFormWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    this.onForgotPassword,
    this.isLoading = false,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  bool _isPasswordVisible = false;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    widget.emailController.addListener(_validateEmail);
    widget.passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    widget.emailController.removeListener(_validateEmail);
    widget.passwordController.removeListener(_validatePassword);
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
  }

  void _validatePassword() {
    final password = widget.passwordController.text;
    setState(() {
      if (password.isEmpty) {
        _passwordError = null;
      } else if (password.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
      } else {
        _passwordError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email Field
          TextFormField(
            controller: widget.emailController,
            enabled: !widget.isLoading,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Email or Username',
              hintText: 'Enter your email or username',
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
                return 'Please enter your email or username';
              }
              return _emailError;
            },
          ),
          SizedBox(height: 2.h),

          // Password Field
          TextFormField(
            controller: widget.passwordController,
            enabled: !widget.isLoading,
            obscureText: !_isPasswordVisible,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock',
                  size: 20,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              suffixIcon: GestureDetector(
                onTap: widget.isLoading
                    ? null
                    : () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName:
                        _isPasswordVisible ? 'visibility' : 'visibility_off',
                    size: 20,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              errorText: _passwordError,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return _passwordError;
            },
          ),
          SizedBox(height: 1.h),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.isLoading ? null : widget.onForgotPassword,
              child: Text(
                'Forgot Password?',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
