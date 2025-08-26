import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SwipeCardWidget extends StatefulWidget {
  final Map<String, dynamic> profile;
  final VoidCallback? onLike;
  final VoidCallback? onPass;
  final VoidCallback? onTap;

  const SwipeCardWidget({
    Key? key,
    required this.profile,
    this.onLike,
    this.onPass,
    this.onTap,
  }) : super(key: key);

  @override
  State<SwipeCardWidget> createState() => _SwipeCardWidgetState();
}

class _SwipeCardWidgetState extends State<SwipeCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _positionAnimation;

  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    const double threshold = 100.0;

    if (_dragOffset.dx.abs() > threshold) {
      if (_dragOffset.dx > 0) {
        _animateCardExit(true);
        widget.onLike?.call();
      } else {
        _animateCardExit(false);
        widget.onPass?.call();
      }
    } else {
      _resetCard();
    }
  }

  void _animateCardExit(bool isLike) {
    final screenWidth = MediaQuery.of(context).size.width;
    _positionAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset(isLike ? screenWidth * 2 : -screenWidth * 2, _dragOffset.dy),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: _dragOffset.dx * 0.001,
      end: isLike ? 0.3 : -0.3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  void _resetCard() {
    _positionAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: _dragOffset.dx * 0.001,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward().then((_) {
      setState(() {
        _dragOffset = Offset.zero;
        _isDragging = false;
      });
      _animationController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final offset = _isDragging ? _dragOffset : _positionAnimation.value;
        final rotation =
            _isDragging ? _dragOffset.dx * 0.001 : _rotationAnimation.value;

        return Transform.translate(
          offset: offset,
          child: Transform.rotate(
            angle: rotation,
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              onTap: widget.onTap,
              child: Container(
                width: 85.w,
                height: 70.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow,
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      // Profile Image
                      Positioned.fill(
                        child: CustomImageWidget(
                          imageUrl: widget.profile['photos']?[0] ?? '',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Gradient Overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.7),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // Profile Information
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${widget.profile['name']}, ${widget.profile['age']}',
                                      style: AppTheme
                                          .lightTheme.textTheme.headlineSmall
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (widget.profile['verified'] == true) ...[
                                    SizedBox(width: 2.w),
                                    CustomIconWidget(
                                      iconName: 'verified',
                                      color: AppTheme
                                          .lightTheme.colorScheme.secondary,
                                      size: 20,
                                    ),
                                  ],
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'location_on',
                                    color: Colors.white.withValues(alpha: 0.8),
                                    size: 16,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    '${widget.profile['distance']} km away',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color:
                                          Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                              if (widget.profile['bio'] != null &&
                                  widget.profile['bio']
                                      .toString()
                                      .isNotEmpty) ...[
                                SizedBox(height: 1.h),
                                Text(
                                  widget.profile['bio'].toString(),
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      // Swipe Indicators
                      if (_isDragging) ...[
                        // Like Indicator
                        if (_dragOffset.dx > 50)
                          Positioned(
                            top: 15.h,
                            right: 5.w,
                            child: Transform.rotate(
                              angle: -0.3,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppTheme
                                        .lightTheme.colorScheme.secondary,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'LIKE',
                                  style: AppTheme
                                      .lightTheme.textTheme.headlineSmall
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.secondary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Pass Indicator
                        if (_dragOffset.dx < -50)
                          Positioned(
                            top: 15.h,
                            left: 5.w,
                            child: Transform.rotate(
                              angle: 0.3,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        AppTheme.lightTheme.colorScheme.error,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'PASS',
                                  style: AppTheme
                                      .lightTheme.textTheme.headlineSmall
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.error,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
