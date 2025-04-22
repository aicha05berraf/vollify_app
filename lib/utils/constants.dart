import 'dart:ui';

class AppColors {
  static const primaryDark = Color(0xFF20331B);
  static const primary = Color(0xFF4E653D);
  static const secondary = Color(0xFF859864);
  static const textPrimary = Color(0xFF333333);
  static const textSecondary = Color(0xFF666666);

  static const primaryLight = Color(0xFFAED581); // أخضر فاتح
  static const accent = Color(0xFFFFC107); // أصفر برتقالي
}

class AppTextStyles {
  static final myTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final subtitle = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
  );
}

class AppStrings {
  static const volunteerOpportunities = 'Search Opportunities';
  static const volunteerAchievements = 'My Achievements';
  static const volunteerNotifications = 'Notifications';
  static const orgPostOpportunities = 'Post Opportunities';
  static const orgManageVolunteers = 'Manage Volunteers';
  static const orgReviews = 'View Reviews';
}
