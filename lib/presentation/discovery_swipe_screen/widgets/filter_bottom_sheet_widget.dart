import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const FilterBottomSheetWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late RangeValues _ageRange;
  late double _maxDistance;
  late String _interestedIn;

  final List<String> _genderOptions = ['Women', 'Men', 'Everyone'];

  @override
  void initState() {
    super.initState();
    _ageRange = RangeValues(
      (widget.currentFilters['minAge'] ?? 18).toDouble(),
      (widget.currentFilters['maxAge'] ?? 35).toDouble(),
    );
    _maxDistance = (widget.currentFilters['maxDistance'] ?? 50).toDouble();
    _interestedIn = widget.currentFilters['interestedIn'] ?? 'Women';
  }

  void _applyFilters() {
    final filters = {
      'minAge': _ageRange.start.round(),
      'maxAge': _ageRange.end.round(),
      'maxDistance': _maxDistance.round(),
      'interestedIn': _interestedIn,
    };
    widget.onFiltersChanged(filters);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discovery Settings',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 4.h),

              // Age Range Section
              Text(
                'Age Range',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 2.h),

              Text(
                '${_ageRange.start.round()} - ${_ageRange.end.round()} years old',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),

              RangeSlider(
                values: _ageRange,
                min: 18,
                max: 65,
                divisions: 47,
                onChanged: (RangeValues values) {
                  setState(() {
                    _ageRange = values;
                  });
                },
              ),

              SizedBox(height: 3.h),

              // Distance Section
              Text(
                'Maximum Distance',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 2.h),

              Text(
                '${_maxDistance.round()} km',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),

              Slider(
                value: _maxDistance,
                min: 1,
                max: 100,
                divisions: 99,
                onChanged: (double value) {
                  setState(() {
                    _maxDistance = value;
                  });
                },
              ),

              SizedBox(height: 3.h),

              // Interested In Section
              Text(
                'Show Me',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 2.h),

              Column(
                children: _genderOptions.map((option) {
                  return RadioListTile<String>(
                    title: Text(
                      option,
                      style: AppTheme.lightTheme.textTheme.bodyLarge,
                    ),
                    value: option,
                    groupValue: _interestedIn,
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _interestedIn = value;
                        });
                      }
                    },
                    contentPadding: EdgeInsets.zero,
                  );
                }).toList(),
              ),

              SizedBox(height: 4.h),

              // Apply Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: Text('Apply Filters'),
                ),
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
