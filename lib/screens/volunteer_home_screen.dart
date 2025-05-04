import 'package:flutter/material.dart';
import 'package:vollify_app/screens/achievements_screen.dart';
import 'package:vollify_app/screens/notifications_screen.dart';
import 'package:vollify_app/screens/opportunity_search_screen.dart';
import 'package:vollify_app/screens/volunteer_profile_screen.dart';
import 'package:vollify_app/utils/constants.dart';

class VolunteerHomeScreen extends StatelessWidget {
  const VolunteerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Dashboard'),
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
                  builder: (context) => const VolunteerProfileScreen(),
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
              Color.fromARGB(255, 25, 68, 26), // أخضر من الأعلى
              Colors.white, // منطقة بيضاء
              Colors.white, // منتصف أبيض واسع
              Color.fromARGB(255, 25, 68, 26), // أخضر من الأسفل
            ],
            stops: [
              0.0,  // بداية الأخضر العلوي
              0.2,  // بداية المنطقة البيضاء
              0.8,  // نهاية المنطقة البيضاء
              1.0,  // نهاية الأخضر السفلي
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionCard(
                    context,
                    AppStrings.volunteerOpportunities,
                    Icons.search,
                    () => _navigateToOpportunitySearch(context),
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 20),
                  _buildActionCard(
                    context,
                    AppStrings.volunteerAchievements,
                    Icons.emoji_events,
                    () => _navigateToAchievements(context),
                    color: AppColors.accent,
                  ),
                  const SizedBox(height: 20),
                  _buildActionCard(
                    context,
                    AppStrings.volunteerNotifications,
                    Icons.notifications,
                    () => _navigateToNotifications(context),
                    color: AppColors.primaryLight,
                  ),
                ],
              ),
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
              const Icon(Icons.arrow_forward, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToOpportunitySearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OpportunitySearchScreen()),
    );
  }

  void _navigateToAchievements(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AchievementsScreen()),
    );
  }

  void _navigateToNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => const NotificationsScreen(userId: 'widget.userId'),
      ),
    );
  }
}
