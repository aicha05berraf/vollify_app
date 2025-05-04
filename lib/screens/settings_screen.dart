import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vollify_app/main.dart';
import 'package:vollify_app/providers/theme_provider.dart';
import 'package:vollify_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context);
    final settingsTitle = localize.translate('settings');
    final changeLanguageText = localize.translate('changeLanguage');
    final toggleDarkModeText = localize.translate('toggleDarkMode');
    final logoutText = localize.translate('logout');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          settingsTitle,
          style: const TextStyle(color: Colors.white), // White title text
        ),
        backgroundColor: const Color(0xFF20331B), // Dark green background
        centerTitle: false, // Align the title to the left
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Settings Icon at the Top
          Center(
            child: Column(
              children: [
                const Icon(
                  Icons.settings,
                  size: 80,
                  color: Color(0xFF4E653D), // Theme accent color
                ),
                const SizedBox(height: 16),
                Text(
                  settingsTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF20331B),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),

          // Change Language
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(changeLanguageText),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ListView(
                    children: [
                      ListTile(
                        title: const Text('Français'),
                        onTap: () {
                          Locale newLocale = const Locale('fr', '');
                          MyApp.setLocale(context, newLocale);
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('English'),
                        onTap: () {
                          Locale newLocale = const Locale('en', '');
                          MyApp.setLocale(context, newLocale);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),

          // Toggle Dark Mode
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: Text(toggleDarkModeText),
            trailing: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (_) => themeProvider.toggleTheme(),
                );
              },
            ),
          ),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              logoutText,
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/userType',
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

// Volunteer Profile Screen
class VolunteerProfileScreen extends StatefulWidget {
  const VolunteerProfileScreen({super.key});

  @override
  _VolunteerProfileScreenState createState() => _VolunteerProfileScreenState();
}

class _VolunteerProfileScreenState extends State<VolunteerProfileScreen> {
  bool _isEditing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['editing'] == true) {
      setState(() {
        _isEditing = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing
            ? localize.translate('editProfile')
            : localize.translate('profile')),
      ),
      body: Center(
        child: _isEditing
            ? const Text('Editing Mode: Make changes to your profile.')
            : const Text('View Mode: Your profile details.'),
      ),
    );
  }
}

// MyApp
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    final MyAppState? state = context.findAncestorStateOfType<MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('fr', ''), // French
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      initialRoute: '/',
      routes: {
        '/': (context) => const SettingsScreen(),
        '/volunteerProfile': (context) => const VolunteerProfileScreen(),
        '/userType': (context) => const Placeholder(), // Replace with your real widget
      },
    );
  }
}
