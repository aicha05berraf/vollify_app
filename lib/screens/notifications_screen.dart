import 'package:flutter/material.dart';
import 'package:vollify_app/utils/constants.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.primaryDark,
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: () => _markAllAsRead(context),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return ListTile(
            leading: Icon(
              notification.icon,
              color: _getNotificationColor(notification.type),
            ),
            title: Text(notification.title),
            subtitle: Text(
              notification.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              notification.time,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onTap: () => _handleNotificationTap(context, notification),
          );
        },
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.accepted:
        return Colors.green;
      case NotificationType.rejected:
        return Colors.red;
      case NotificationType.newOpportunity:
        return AppColors.primary;
      case NotificationType.reminder:
        return Colors.orange;
      // ignore: unreachable_switch_default
      default:
        return Colors.grey;
    }
  }

  void _markAllAsRead(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  void _handleNotificationTap(
    BuildContext context,
    AppNotification notification,
  ) {
    // Handle navigation based on notification type
  }
}

// Sample data models
enum NotificationType { accepted, rejected, newOpportunity, reminder }

class AppNotification {
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  final IconData icon;

  AppNotification({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.icon,
  });
}

final List<AppNotification> _notifications = [
  AppNotification(
    title: 'Application Accepted',
    message: 'Your application for "Community Cleanup" has been accepted',
    time: '2 hours ago',
    type: NotificationType.accepted,
    icon: Icons.check_circle,
  ),
  // Add more notifications...
];
