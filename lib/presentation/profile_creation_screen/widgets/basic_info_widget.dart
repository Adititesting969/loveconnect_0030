import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BasicInfoWidget extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController locationController;
  final Function(String) onLocationChanged;

  const BasicInfoWidget({
    Key? key,
    required this.nameController,
    required this.ageController,
    required this.locationController,
    required this.onLocationChanged,
  }) : super(key: key);

  @override
  State<BasicInfoWidget> createState() => _BasicInfoWidgetState();
}

class _BasicInfoWidgetState extends State<BasicInfoWidget> {
  bool _isLocationLoading = false;

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLocationLoading = true;
    });

    try {
      // Simulate location fetching - in real app, use geolocator package
      await Future.delayed(Duration(seconds: 1));

      // Mock location data
      final mockLocations = [
        'New York, NY',
        'Los Angeles, CA',
        'Chicago, IL',
        'Houston, TX',
        'Phoenix, AZ',
        'Philadelphia, PA',
        'San Antonio, TX',
        'San Diego, CA',
      ];

      final randomLocation =
          mockLocations[DateTime.now().millisecond % mockLocations.length];
      widget.locationController.text = randomLocation;
      widget.onLocationChanged(randomLocation);
    } catch (e) {
      debugPrint('Location fetch failed: $e');
    } finally {
      setState(() {
        _isLocationLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: AppTheme.lightTheme.colorScheme.shadow,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            TextFormField(
              controller: widget.nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'person',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                if (value.trim().length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
            ),
            SizedBox(height: 3.h),
            TextFormField(
              controller: widget.ageController,
              decoration: InputDecoration(
                labelText: 'Age',
                hintText: 'Enter your age',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'cake',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                final age = int.tryParse(value);
                if (age == null) {
                  return 'Please enter a valid age';
                }
                if (age < 18) {
                  return 'You must be at least 18 years old';
                }
                if (age > 100) {
                  return 'Please enter a valid age';
                }
                return null;
              },
            ),
            SizedBox(height: 3.h),
            TextFormField(
              controller: widget.locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                hintText: 'Enter your location',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'location_on',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                suffixIcon: _isLocationLoading
                    ? Padding(
                        padding: EdgeInsets.all(3.w),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: _getCurrentLocation,
                        icon: CustomIconWidget(
                          iconName: 'my_location',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                        tooltip: 'Use current location',
                      ),
              ),
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.words,
              onChanged: widget.onLocationChanged,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your location';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
