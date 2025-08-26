import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InterestsWidget extends StatefulWidget {
  final List<String> selectedInterests;
  final Function(List<String>) onInterestsChanged;

  const InterestsWidget({
    Key? key,
    required this.selectedInterests,
    required this.onInterestsChanged,
  }) : super(key: key);

  @override
  State<InterestsWidget> createState() => _InterestsWidgetState();
}

class _InterestsWidgetState extends State<InterestsWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredInterests = [];
  bool _isSearching = false;

  final List<String> _popularInterests = [
    'Travel',
    'Photography',
    'Cooking',
    'Fitness',
    'Music',
    'Movies',
    'Reading',
    'Dancing',
    'Hiking',
    'Art',
    'Gaming',
    'Sports',
    'Yoga',
    'Coffee',
    'Wine',
    'Fashion',
    'Technology',
    'Nature',
    'Pets',
    'Food',
    'Beach',
    'Adventure',
    'Comedy',
    'History',
    'Science',
    'Writing',
    'Meditation',
    'Running',
    'Swimming',
    'Cycling',
  ];

  @override
  void initState() {
    super.initState();
    _filteredInterests = List.from(_popularInterests);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredInterests = List.from(_popularInterests);
      } else {
        _filteredInterests = _popularInterests
            .where((interest) => interest.toLowerCase().contains(query))
            .toList();

        // Add custom interest if it doesn't exist
        if (!_filteredInterests
                .any((interest) => interest.toLowerCase() == query) &&
            query.length > 2) {
          _filteredInterests.insert(0, _searchController.text);
        }
      }
    });
  }

  void _toggleInterest(String interest) {
    final List<String> updatedInterests = List.from(widget.selectedInterests);

    if (updatedInterests.contains(interest)) {
      updatedInterests.remove(interest);
    } else {
      if (updatedInterests.length < 10) {
        updatedInterests.add(interest);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You can select up to 10 interests'),
            backgroundColor: AppTheme.warningLight,
          ),
        );
        return;
      }
    }

    widget.onInterestsChanged(updatedInterests);
  }

  void _clearSearch() {
    _searchController.clear();
    FocusScope.of(context).unfocus();
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Interests',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '${widget.selectedInterests.length}/10',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: widget.selectedInterests.length >= 10
                        ? AppTheme.warningLight
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              'Select interests that represent you (minimum 3)',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),

            // Search field
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search or add custom interests...',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                suffixIcon: _isSearching
                    ? IconButton(
                        onPressed: _clearSearch,
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      )
                    : null,
              ),
              textInputAction: TextInputAction.search,
              textCapitalization: TextCapitalization.words,
            ),
            SizedBox(height: 3.h),

            // Selected interests
            if (widget.selectedInterests.isNotEmpty) ...[
              Text(
                'Selected Interests',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: widget.selectedInterests.map((interest) {
                  return Chip(
                    label: Text(
                      interest,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    deleteIcon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 16,
                    ),
                    onDeleted: () => _toggleInterest(interest),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 3.h),
            ],

            // Available interests
            Text(
              _isSearching ? 'Search Results' : 'Popular Interests',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              constraints: BoxConstraints(maxHeight: 25.h),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: _filteredInterests.map((interest) {
                    final isSelected =
                        widget.selectedInterests.contains(interest);
                    final isCustom = !_popularInterests.contains(interest);

                    return FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isCustom) ...[
                            CustomIconWidget(
                              iconName: 'add',
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.onPrimary
                                  : AppTheme.lightTheme.colorScheme.primary,
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                          ],
                          Text(
                            interest,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.onPrimary
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (_) => _toggleInterest(interest),
                      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                      selectedColor: AppTheme.lightTheme.colorScheme.primary,
                      checkmarkColor: AppTheme.lightTheme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
