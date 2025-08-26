import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class PhotoCarouselWidget extends StatefulWidget {
  final List<String> photos;
  final Function(int)? onPhotoTap;

  const PhotoCarouselWidget({
    Key? key,
    required this.photos,
    this.onPhotoTap,
  }) : super(key: key);

  @override
  State<PhotoCarouselWidget> createState() => _PhotoCarouselWidgetState();
}

class _PhotoCarouselWidgetState extends State<PhotoCarouselWidget> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      width: double.infinity,
      child: Stack(
        children: [
          // Photo PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.photos.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => widget.onPhotoTap?.call(index),
                child: Container(
                  width: double.infinity,
                  height: 60.h,
                  child: CustomImageWidget(
                    imageUrl: widget.photos[index],
                    width: double.infinity,
                    height: 60.h,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),

          // Gradient overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 15.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Page indicators
          if (widget.photos.length > 1)
            Positioned(
              bottom: 2.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.photos.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                    width: _currentIndex == index ? 4.w : 2.w,
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(1.h),
                    ),
                  ),
                ),
              ),
            ),

          // Photo counter
          if (widget.photos.length > 1)
            Positioned(
              top: 6.h,
              right: 4.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(4.w),
                ),
                child: Text(
                  '${_currentIndex + 1}/${widget.photos.length}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
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
