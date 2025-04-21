import 'package:flutter/material.dart';
import 'package:vollify_app/screens/achievements_screen.dart';
import 'package:vollify_app/screens/manage_volunteers_screen.dart';
import 'package:vollify_app/screens/notifications_screen.dart';
import 'package:vollify_app/screens/opportunity_search_screen.dart';
import 'package:vollify_app/screens/organization_profile_screen.dart';
import 'package:vollify_app/screens/organization_reviews_screen.dart';
import 'package:vollify_app/screens/post_opportunity_screen.dart';
import 'package:vollify_app/screens/splash_screen.dart';
import 'package:vollify_app/screens/login_screen.dart';
import 'package:vollify_app/screens/user_type_screen.dart';
import 'package:vollify_app/screens/volunteer_signup_screen.dart';
import 'package:vollify_app/screens/organization_signup_screen.dart';
import 'package:vollify_app/screens/volunteer_home_screen.dart';
import 'package:vollify_app/screens/organization_home_screen.dart';
import 'package:vollify_app/screens/volunteer_profile_screen.dart';
import 'package:vollify_app/database_helper.db';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper();
  await dbHelper.insertSampleVolunteer(); // Creates DB and adds 1 row
  runApp(const VolunteerApp());
}

class VolunteerApp extends StatelessWidget {
  const VolunteerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Volunteer Connect',
      theme: ThemeData(
        primarySwatch: createMaterialColor(const Color(0xFF20331B)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Initial route
      home: const SplashScreen(),
      // Named routes for all screens
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/userType': (context) => const UserTypeScreen(),
        '/volunteerSignup': (context) => const VolunteerSignupScreen(),
        '/organizationSignup': (context) => OrganizationSignupScreen(),
        '/volunteerProfile': (context) => VolunteerProfileScreen(),
        '/organizationProfile': (context) => OrganizationProfileScreen(),
        '/volunteerHome': (context) => VolunteerHomeScreen(),
        '/organizationHome': (context) => OrganizationHomeScreen(),
        '/login': (context) => LoginScreen(),
        '/opportunitySearch': (context) => OpportunitySearchScreen(),
        '/notifications': (context) => NotificationsScreen(),
        '/achievements': (context) => AchievementsScreen(),
        '/postOpportunity': (context) => PostOpportunityScreen(),
        '/manageVolunteers': (context) => ManageVolunteersScreen(),
        '/organizationReviews': (context) => OrganizationReviewsScreen(),
      },

      debugShowCheckedModeBanner: false,
    );
  }

  createMaterialColor(Color color) {}
}

// Your existing createMaterialColor function...
