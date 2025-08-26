import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class PhotoViewerWidget extends StatefulWidget {
  final List<String> photos;
  final int initialIndex;
  final Function()? onClose;
  final Function(String)? onReport;

  const PhotoViewerWidget({
    Key? key,
    required this.photos,
    this.initialIndex = 0,
    this.onClose,
    this.onReport,
  }) : super(key: key);

  @override
  State<PhotoViewerWidget> createState() => _PhotoViewerWidgetState();
}

class _PhotoViewerWidgetState extends State<PhotoViewerWidget>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late TransformationController _transformationController;
  late AnimationController _animationController;
  int _currentIndex = 0;
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _transformationController = TransformationController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _transformationController.addListener(_onTransformationChanged);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onTransformationChanged() {
    final Matrix4 matrix = _transformationController.value;
    final double scale = matrix.getMaxScaleOnAxis();
    final bool isCurrentlyZoomed = scale > 1.0;

    if (isCurrentlyZoomed != _isZoomed) {
      setState(() {
        _isZoomed = isCurrentlyZoomed;
      });
    }
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Report Photo',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to report this photo as inappropriate?',
          style: AppTheme.lightTheme.textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onReport?.call(widget.photos[_currentIndex]);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Photo reported successfully'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                ),
              );
            },
            child: Text(
              'Report',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Photo viewer
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              _resetZoom();
            },
            itemCount: widget.photos.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                transformationController: _transformationController,
                minScale: 1.0,
                maxScale: 4.0,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: CustomImageWidget(
                    imageUrl: widget.photos[index],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),

          // Top bar with close button and menu
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: widget.onClose,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'close',
                          color: Colors.white,
                          size: 6.w,
                        ),
                      ),
                    ),

                    // Photo counter
                    if (widget.photos.length > 1)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(4.w),
                        ),
                        child: Text(
                          '${_currentIndex + 1}/${widget.photos.length}',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    // Menu button
                    PopupMenuButton<String>(
                      icon: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'more_vert',
                          color: Colors.white,
                          size: 6.w,
                        ),
                      ),
                      color: AppTheme.lightTheme.colorScheme.surface,
                      onSelected: (value) {
                        if (value == 'report') {
                          _showReportDialog();
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'report',
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'report',
                                color: AppTheme.lightTheme.colorScheme.error,
                                size: 5.w,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                'Report Photo',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom indicators
          if (widget.photos.length > 1)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.photos.length,
                      (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 1.w),
                        width: _currentIndex == index ? 6.w : 2.w,
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
              ),
            ),
        ],
      ),
    );
  }
}
