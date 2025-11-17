import 'package:flutter/material.dart';

enum AppNotificationType { success, info, error }

class NotificationService {
  NotificationService._(); // private constructor so no one instantiates this

  static void show(
    BuildContext context, {
    required String title,
    required String message,
    AppNotificationType type = AppNotificationType.info,
  }) {
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case AppNotificationType.success:
        backgroundColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case AppNotificationType.error:
        backgroundColor = Colors.red;
        icon = Icons.error;
        break;
      case AppNotificationType.info:
      default:
        backgroundColor = Colors.blue;
        icon = Icons.info;
        break;
    }

    // Close any current snackbars first
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        margin: const EdgeInsets.all(16),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  static void showSuccess(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    show(
      context,
      title: title,
      message: message,
      type: AppNotificationType.success,
    );
  }

  static void showError(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    show(
      context,
      title: title,
      message: message,
      type: AppNotificationType.error,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    show(
      context,
      title: title,
      message: message,
      type: AppNotificationType.info,
    );
  }
}
