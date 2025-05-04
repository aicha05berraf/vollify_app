import 'package:flutter/material.dart';
import 'package:vollify_app/screens/manage_volunteers_screen.dart';
import 'package:vollify_app/screens/organization_reviews_screen.dart';
import 'package:vollify_app/screens/post_opportunity_screen.dart';
import 'package:vollify_app/screens/organization_profile_screen.dart';
import 'package:vollify_app/utils/constants.dart';

class OrganizationHomeScreen extends StatelessWidget {
  const OrganizationHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Dashboard'),
        backgroundColor: AppColors.primaryDark,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrganizationProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromARGB(255, 25, 68, 26), // أخضر غامق من الأعلى
        Colors.white,                    // بداية الأبيض
        Colors.white,                    // منتصف أبيض واسع
        Color.fromARGB(255, 25, 68, 26), // أخضر غامق من الأسفل
      ],
      stops: [
        0.0,  // بداية التدرج العلوي
        0.2,  // بداية الأبيض
        0.8,  // نهاية الأبيض
        1.0,  // نهاية التدرج السفلي
      ],
    ),
  ),
  child: Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActionCard(
            context,
            'Post Opportunities',
            Icons.post_add,
            () => _navigateToPostOpportunity(context),
            color: AppColors.primary,
          ),
          const SizedBox(height: 20),
          _buildActionCard(
            context,
            'Manage Volunteers',
            Icons.people,
            () => _navigateToManageVolunteers(context),
            color: AppColors.accent,
          ),
          const SizedBox(height: 20),
          _buildActionCard(
            context,
            'View Reviews',
            Icons.star,
            () => _navigateToReviews(context),
            color: AppColors.primaryLight,
          ),
        ],
      ),
    ),
  ),
),

    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    required Color color,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPostOpportunity(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PostOpportunityScreen()),
    );
  }

  void _navigateToManageVolunteers(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ManageVolunteersScreen()),
    );
  }

  void _navigateToReviews(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OrganizationReviewsScreen(),
      ),
    );
  }
}
