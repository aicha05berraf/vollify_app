import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vollify_app/l10n/app_localizations.dart';
import 'package:vollify_app/providers/theme_provider.dart';
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
import 'package:vollify_app/screens/volunteer_profile_screen.dart' as volunteer_profile;
import 'package:vollify_app/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Volunteer Connect',
            theme: ThemeData(
              primarySwatch: createMaterialColor(const Color(0xFF20331B)),
              brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            locale: _locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('fr', ''),
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            // Initial route
      home: const SplashScreen(),
      // Named routes for all screens
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/userType': (context) => const UserTypeScreen(),
        '/volunteerSignup': (context) => const VolunteerSignupScreen(),
        '/organizationSignup': (context) => const OrganizationSignUpScreen(),
        '/volunteerProfile': (context) => VolunteerProfileScreen(),
        '/organizationProfile': (context) => OrganizationProfileScreen(),
        '/volunteerHome': (context) => VolunteerHomeScreen(),
        '/organizationHome': (context) => OrganizationHomeScreen(),
        '/login': (context) => LoginScreen(),
        '/opportunitySearch': (context) => OpportunitySearchScreen(),
        '/notifications': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as String;
          return NotificationsScreen(userId: args);
        },

        '/achievements': (context) => AchievementsScreen(),
        '/postOpportunity': (context) => PostOpportunityScreen(),
        '/manageVolunteers': (context) => ManageVolunteersScreen(),
        '/organizationReviews': (context) => OrganizationReviewsScreen(),
      },

      debugShowCheckedModeBanner: false,
          );
        },
      ),



    );
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    // ignore: deprecated_member_use
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    // ignore: deprecated_member_use
    return MaterialColor(color.value, swatch);
  }
}
