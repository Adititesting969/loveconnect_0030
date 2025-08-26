import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/profile_detail_modal/profile_detail_modal.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/discovery_swipe_screen/discovery_swipe_screen.dart';
import '../presentation/profile_creation_screen/profile_creation_screen.dart';
import '../presentation/matches_screen/matches_screen.dart';
import '../presentation/chat_messaging_screen/chat_messaging_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/user_profile_screen/user_profile_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String settings = '/settings-screen';
  static const String profileDetailModal = '/profile-detail-modal';
  static const String login = '/login-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String discoverySwipe = '/discovery-swipe-screen';
  static const String profileCreation = '/profile-creation-screen';
  static const String matches = '/matches-screen';
  static const String chatMessaging = '/chat-messaging-screen';
  static const String registration = '/registration-screen';
  static const String userProfile = '/user-profile-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    settings: (context) => const SettingsScreen(),
    profileDetailModal: (context) => const ProfileDetailModal(),
    login: (context) => const LoginScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    discoverySwipe: (context) => const DiscoverySwipeScreen(),
    profileCreation: (context) => const ProfileCreationScreen(),
    matches: (context) => const MatchesScreen(),
    chatMessaging: (context) => const ChatMessagingScreen(),
    registration: (context) => const RegistrationScreen(),
    userProfile: (context) => const UserProfileScreen(),
    // TODO: Add your other routes here
  };
}
