import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_tabs_widget.dart';
import './widgets/match_card_widget.dart';
import './widgets/quick_message_modal.dart';
import './widgets/search_bar_widget.dart';
import './widgets/unmatch_confirmation_dialog.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({Key? key}) : super(key: key);

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _filterTabs = [
    'All Matches',
    'Recent Activity',
    'Unread Messages'
  ];
  int _selectedFilterIndex = 0;
  List<Map<String, dynamic>> _allMatches = [];
  List<Map<String, dynamic>> _filteredMatches = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeMatches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initializeMatches() {
    _allMatches = [
      {
        "id": 1,
        "name": "Emma Rodriguez",
        "profileImage":
            "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
        "lastMessage":
            "That sounds like an amazing adventure! I'd love to hear more about your hiking trip.",
        "timeAgo": "2m",
        "hasUnreadMessages": true,
        "isNewMatch": false,
        "matchDate": DateTime.now().subtract(const Duration(days: 2)),
        "lastActivity": DateTime.now().subtract(const Duration(minutes: 2)),
      },
      {
        "id": 2,
        "name": "Sophia Chen",
        "profileImage":
            "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
        "lastMessage": "",
        "timeAgo": "5m",
        "hasUnreadMessages": false,
        "isNewMatch": true,
        "matchDate": DateTime.now().subtract(const Duration(minutes: 5)),
        "lastActivity": DateTime.now().subtract(const Duration(minutes: 5)),
      },
      {
        "id": 3,
        "name": "Isabella Martinez",
        "profileImage":
            "https://images.pexels.com/photos/1181686/pexels-photo-1181686.jpeg?auto=compress&cs=tinysrgb&w=400",
        "lastMessage": "Coffee sounds perfect! How about Saturday morning?",
        "timeAgo": "1h",
        "hasUnreadMessages": true,
        "isNewMatch": false,
        "matchDate": DateTime.now().subtract(const Duration(days: 1)),
        "lastActivity": DateTime.now().subtract(const Duration(hours: 1)),
      },
      {
        "id": 4,
        "name": "Ava Thompson",
        "profileImage":
            "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=400",
        "lastMessage":
            "I completely agree! That movie was incredible. The cinematography was stunning.",
        "timeAgo": "3h",
        "hasUnreadMessages": false,
        "isNewMatch": false,
        "matchDate": DateTime.now().subtract(const Duration(days: 5)),
        "lastActivity": DateTime.now().subtract(const Duration(hours: 3)),
      },
      {
        "id": 5,
        "name": "Mia Johnson",
        "profileImage":
            "https://images.pexels.com/photos/1542085/pexels-photo-1542085.jpeg?auto=compress&cs=tinysrgb&w=400",
        "lastMessage":
            "Thanks for the book recommendation! I just ordered it online.",
        "timeAgo": "1d",
        "hasUnreadMessages": false,
        "isNewMatch": false,
        "matchDate": DateTime.now().subtract(const Duration(days: 7)),
        "lastActivity": DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        "id": 6,
        "name": "Charlotte Wilson",
        "profileImage":
            "https://images.pexels.com/photos/1858175/pexels-photo-1858175.jpeg?auto=compress&cs=tinysrgb&w=400",
        "lastMessage": "",
        "timeAgo": "2d",
        "hasUnreadMessages": false,
        "isNewMatch": true,
        "matchDate": DateTime.now().subtract(const Duration(days: 2)),
        "lastActivity": DateTime.now().subtract(const Duration(days: 2)),
      },
      {
        "id": 7,
        "name": "Amelia Davis",
        "profileImage":
            "https://images.pexels.com/photos/1382731/pexels-photo-1382731.jpeg?auto=compress&cs=tinysrgb&w=400",
        "lastMessage":
            "Your travel photos are amazing! Which destination was your favorite?",
        "timeAgo": "3d",
        "hasUnreadMessages": true,
        "isNewMatch": false,
        "matchDate": DateTime.now().subtract(const Duration(days: 10)),
        "lastActivity": DateTime.now().subtract(const Duration(days: 3)),
      },
      {
        "id": 8,
        "name": "Harper Brown",
        "profileImage":
            "https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg?auto=compress&cs=tinysrgb&w=400",
        "lastMessage":
            "I'd love to try that new restaurant you mentioned. When are you free?",
        "timeAgo": "1w",
        "hasUnreadMessages": false,
        "isNewMatch": false,
        "matchDate": DateTime.now().subtract(const Duration(days: 14)),
        "lastActivity": DateTime.now().subtract(const Duration(days: 7)),
      },
    ];
    _applyFilters();
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allMatches);

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((match) {
        final name = (match['name'] as String).toLowerCase();
        final searchTerm = _searchController.text.toLowerCase();
        return name.contains(searchTerm);
      }).toList();
    }

    // Apply tab filter
    switch (_selectedFilterIndex) {
      case 0: // All Matches
        break;
      case 1: // Recent Activity
        filtered = filtered.where((match) {
          final lastActivity = match['lastActivity'] as DateTime;
          final now = DateTime.now();
          return now.difference(lastActivity).inHours <= 24;
        }).toList();
        break;
      case 2: // Unread Messages
        filtered = filtered
            .where((match) => match['hasUnreadMessages'] == true)
            .toList();
        break;
    }

    // Sort by activity (new matches first, then by last activity)
    filtered.sort((a, b) {
      if (a['isNewMatch'] == true && b['isNewMatch'] != true) return -1;
      if (b['isNewMatch'] == true && a['isNewMatch'] != true) return 1;

      final aActivity = a['lastActivity'] as DateTime;
      final bActivity = b['lastActivity'] as DateTime;
      return bActivity.compareTo(aActivity);
    });

    setState(() {
      _filteredMatches = filtered;
    });
  }

  void _onSearchChanged(String value) {
    _applyFilters();
  }

  void _clearSearch() {
    _searchController.clear();
    _applyFilters();
  }

  void _onFilterTabSelected(int index) {
    setState(() {
      _selectedFilterIndex = index;
    });
    _applyFilters();
  }

  void _onMatchTap(Map<String, dynamic> match) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/chat-messaging-screen', arguments: match);
  }

  void _onUnmatch(Map<String, dynamic> match) {
    showDialog(
      context: context,
      builder: (context) => UnmatchConfirmationDialog(
        matchName: match['name'],
        onConfirm: () {
          setState(() {
            _allMatches.removeWhere((m) => m['id'] == match['id']);
          });
          _applyFilters();
          Fluttertoast.showToast(
            msg: "Unmatched with ${match['name']}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        },
      ),
    );
  }

  void _onQuickMessage(Map<String, dynamic> match) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickMessageModal(
        matchName: match['name'],
        onSendMessage: (message) {
          _sendQuickMessage(match, message);
        },
      ),
    );
  }

  void _sendQuickMessage(Map<String, dynamic> match, String message) {
    // Update match with new message
    setState(() {
      final matchIndex = _allMatches.indexWhere((m) => m['id'] == match['id']);
      if (matchIndex != -1) {
        _allMatches[matchIndex]['lastMessage'] = message;
        _allMatches[matchIndex]['timeAgo'] = 'now';
        _allMatches[matchIndex]['lastActivity'] = DateTime.now();
        _allMatches[matchIndex]['isNewMatch'] = false;
      }
    });
    _applyFilters();

    Fluttertoast.showToast(
      msg: "Message sent to ${match['name']}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    // Navigate to chat screen
    Navigator.pushNamed(context, '/chat-messaging-screen', arguments: match);
  }

  void _onKeepSwiping() {
    Navigator.pushNamed(context, '/discovery-swipe-screen');
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network refresh
    await Future.delayed(const Duration(seconds: 1));

    // Add a new match to simulate refresh
    if (_allMatches.isNotEmpty) {
      final newMatch = {
        "id": DateTime.now().millisecondsSinceEpoch,
        "name": "New Match",
        "profileImage":
            "https://images.pexels.com/photos/1674752/pexels-photo-1674752.jpeg?auto=compress&cs=tinysrgb&w=400",
        "lastMessage": "",
        "timeAgo": "now",
        "hasUnreadMessages": false,
        "isNewMatch": true,
        "matchDate": DateTime.now(),
        "lastActivity": DateTime.now(),
      };

      setState(() {
        _allMatches.insert(0, newMatch);
        _isLoading = false;
      });
      _applyFilters();

      HapticFeedback.lightImpact();
      Fluttertoast.showToast(
        msg: "New match found!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMatchContextMenu(Map<String, dynamic> match) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text(
                'View Profile',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile-detail-modal',
                    arguments: match);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'heart_broken',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 6.w,
              ),
              title: Text(
                'Unmatch',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _onUnmatch(match);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'block',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 6.w,
              ),
              title: Text(
                'Block',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Fluttertoast.showToast(
                  msg: "${match['name']} has been blocked",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'report',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 6.w,
              ),
              title: Text(
                'Report',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Fluttertoast.showToast(
                  msg:
                      "Report submitted. Thank you for keeping our community safe.",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  int get _unreadCount {
    return _allMatches
        .where((match) => match['hasUnreadMessages'] == true)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Matches',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_unreadCount > 0) ...[
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _unreadCount.toString(),
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        elevation: 0,
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onClear: _clearSearch,
            ),
            FilterTabsWidget(
              selectedIndex: _selectedFilterIndex,
              onTabSelected: _onFilterTabSelected,
              tabs: _filterTabs,
            ),
            Expanded(
              child: _filteredMatches.isEmpty
                  ? EmptyStateWidget(onKeepSwiping: _onKeepSwiping)
                  : RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _filteredMatches.length,
                        itemBuilder: (context, index) {
                          final match = _filteredMatches[index];
                          return GestureDetector(
                            onLongPress: () => _showMatchContextMenu(match),
                            child: MatchCardWidget(
                              match: match,
                              onTap: () => _onMatchTap(match),
                              onUnmatch: () => _onUnmatch(match),
                              onQuickMessage: () => _onQuickMessage(match),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
