import 'package:flutter/material.dart';
import 'package:vollify_app/screens/manage_volunteers_screen.dart';
import 'package:vollify_app/screens/organization_reviews_screen.dart';
import 'package:vollify_app/screens/post_opportunity_screen.dart';
import 'package:vollify_app/utils/constants.dart';

class OrganizationHomeScreen extends StatelessWidget {
  const OrganizationHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Dashboard'),
        backgroundColor: AppColors.primaryDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildActionCard(
              context,
              AppStrings.orgPostOpportunities,
              Icons.post_add,
              () => _navigateToPostOpportunity(context),
              color: AppColors.primary,
            ),
            const SizedBox(height: 20),
            _buildActionCard(
              context,
              AppStrings.orgManageVolunteers,
              Icons.people,
              () => _navigateToManageVolunteers(context),
              color: AppColors.accent,
            ),
            const SizedBox(height: 20),
            _buildActionCard(
              context,
              AppStrings.orgReviews,
              Icons.star,
              () => _navigateToReviews(context),
              color: AppColors.primaryLight,
            ),
          ],
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
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
