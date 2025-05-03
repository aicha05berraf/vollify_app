import 'package:flutter/material.dart';
import 'package:vollify_app/utils/constants.dart';
import 'package:vollify_app/services/api_service.dart';
import 'dart:convert';

class NotificationsScreen extends StatefulWidget {
  final String userId;

  const NotificationsScreen({super.key, required this.userId});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ApiService _apiService = ApiService();
  List<AppNotification> _notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  void _fetchNotifications() async {
    try {
      final response = await _apiService.getNotifications(
        int.parse(widget.userId),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _notifications =
              data.map((json) => AppNotification.fromJson(json)).toList();
        });
      } else {
        final responseData = jsonDecode(response.body);
        _showError(responseData['message'] ?? 'Failed to fetch notifications.');
      }
    } catch (e) {
      _showError('An error occurred: $e');
    }
  }

  void _markAllAsRead() async {
    try {
      final response = await _apiService.markAllNotificationsAsRead(
        int.parse(widget.userId),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All notifications marked as read')),
        );
        _fetchNotifications(); // Refresh notifications
      } else {
        final responseData = jsonDecode(response.body);
        _showError(
          responseData['message'] ?? 'Failed to mark notifications as read.',
        );
      }
    } catch (e) {
      _showError('An error occurred: $e');
    }
  }

  void _handleNotificationTap(AppNotification notification) {
    // Navigate or show details based on type
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.primaryDark,
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: _markAllAsRead,
          ),
        ],
      ),
      body:
          _notifications.isEmpty
              ? const Center(child: Text('No notifications yet.'))
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _notifications.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return ListTile(
                    leading: Icon(
                      notification.icon,
                      color: _getNotificationColor(notification.type),
                    ),
                    title: Text(notification.title),
                    subtitle: Text(notification.message),
                    trailing: Text(
                      notification.time,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    onTap: () => _handleNotificationTap(notification),
                  );
                },
              ),
    );
  }
}

// Types + Model

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

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      title: json['title'] ?? 'No title',
      message: json['message'] ?? '',
      time: json['time'] ?? '',
      type: _parseType(json['type']),
      icon: Icons.notifications, // you can change based on type if needed
    );
  }

  static NotificationType _parseType(String? typeStr) {
    switch (typeStr) {
      case 'accepted':
        return NotificationType.accepted;
      case 'rejected':
        return NotificationType.rejected;
      case 'newOpportunity':
        return NotificationType.newOpportunity;
      case 'reminder':
        return NotificationType.reminder;
      default:
        return NotificationType.reminder;
    }
  }
}
