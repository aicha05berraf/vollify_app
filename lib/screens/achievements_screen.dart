import 'package:flutter/material.dart';
import 'package:vollify_app/utils/constants.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Achievements'),
        backgroundColor: AppColors.primaryDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildAchievementBadge('First Timer', Icons.star, true),
            _buildAchievementBadge('Community Hero', Icons.eco, true),
            _buildAchievementBadge(
              'Super Volunteer',
              Icons.volunteer_activism,
              false,
            ),
            _buildAchievementBadge('100 Hours', Icons.timer, false),
            _buildAchievementBadge('5 Events', Icons.event, true),
            _buildAchievementBadge('Team Player', Icons.people, false),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementBadge(String title, IconData icon, bool unlocked) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color:
          // ignore: deprecated_member_use
          unlocked ? AppColors.primaryLight.withOpacity(0.2) : Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: unlocked ? AppColors.primary : Colors.grey,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: unlocked ? AppColors.primaryDark : Colors.grey,
            ),
          ),
          if (!unlocked)
            const Text(
              'Locked',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
        ],
      ),
    );
  }
}
