import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TypingIndicatorWidget extends StatefulWidget {
  final String userName;

  const TypingIndicatorWidget({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  State<TypingIndicatorWidget> createState() => _TypingIndicatorWidgetState();
}

class _TypingIndicatorWidgetState extends State<TypingIndicatorWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      child: Row(
        children: [
          CircleAvatar(
            radius: 2.5.w,
            backgroundColor:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            child: CustomIconWidget(
              iconName: 'person',
              size: 3.w,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(width: 2.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(4.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.userName} is typing',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontSize: 12.sp,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(width: 2.w),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Row(
                      children: List.generate(3, (index) {
                        final delay = index * 0.2;
                        final animationValue =
                            (_animation.value - delay).clamp(0.0, 1.0);
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                          child: Transform.scale(
                            scale: 0.5 + (animationValue * 0.5),
                            child: Container(
                              width: 1.5.w,
                              height: 1.5.w,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary
                                    .withValues(
                                        alpha: 0.3 + (animationValue * 0.7)),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
