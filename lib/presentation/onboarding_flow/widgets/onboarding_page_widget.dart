import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final bool isLastPage;

  const OnboardingPageWidget({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    this.isLastPage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        child: Column(
          children: [
            // Hero Image Section (60% of screen height)
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: 60.h,
                  minHeight: 30.h,
                ),
                child: CustomImageWidget(
                  imageUrl: imagePath,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Content Section (40% of screen height)
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    title,
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 2.h),

                  // Description
                  Flexible(
                    child: Text(
                      description,
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
