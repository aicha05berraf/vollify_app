import 'package:flutter/material.dart';
import 'package:vollify_app/screens/login_screen.dart';
import 'package:vollify_app/screens/organization_signup_screen.dart';
import 'package:vollify_app/screens/volunteer_signup_screen.dart';

// Define AppColors
class AppColors {
  static const Color primaryDark = Color(0xFF1A4D2E); // Replace with your desired color
}

class UserTypeScreen extends StatelessWidget {
  const UserTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF20331B),
        title: const Text(
          'Choose Your Role',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Section
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_circle,
                      size: 60,
                      color: Color(0xFF1A4D2E),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'How would you like to join us?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose the role that fits you to start your journey',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Volunteer Card
              _buildRoleCard(
                context,
                icon: Icons.people_alt,
                title: 'Volunteer',
                description: 'Find volunteer opportunities that suit your skills',
                color: const Color(0xFF2E7D32),
                iconBgColor: const Color(0xFFE8F5E9),
              ),
              const SizedBox(height: 20),

              // Organization Card
              _buildRoleCard(
                context,
                icon: Icons.business,
                title: 'Organization',
                description: 'Post your own volunteering opportunities',
                color: const Color(0xFF2E7D32),
                iconBgColor: const Color(0xFFE8F5E9),
              ),
              const SizedBox(height: 32),

              // Login Prompt
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: const TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: const Color(0xFF1A4D2E),
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
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required Color iconBgColor,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        if (title == 'Volunteer') {
          Navigator.pushNamed(context, '/volunteerSignup');
        } else {
          Navigator.pushNamed(context, '/organizationSignup');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
          border: Border.all(
            // ignore: deprecated_member_use
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
