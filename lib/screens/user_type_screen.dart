import 'package:flutter/material.dart';
import 'package:vollify_app/screens/login_screen.dart';
import 'package:vollify_app/screens/organization_signup_screen.dart';
import 'package:vollify_app/screens/volunteer_signup_screen.dart';
import 'package:vollify_app/utils/constants.dart';
import 'package:vollify_app/widgets/role_card.dart';

class UserTypeScreen extends StatelessWidget {
  const UserTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Join as',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 40),
                RoleCard(
                  icon: Icons.volunteer_activism,
                  title: 'Volunteer',
                  color: AppColors.primary,
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VolunteerSignupScreen(),
                        ),
                      ),
                ),
                const SizedBox(height: 20),
                RoleCard(
                  icon: Icons.business,
                  title: 'Organization',
                  color: AppColors.secondary,
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const OrganizationSignupScreen(),
                        ),
                      ),
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: AppColors.textSecondary),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
