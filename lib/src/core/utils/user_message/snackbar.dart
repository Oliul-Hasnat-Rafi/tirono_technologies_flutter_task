import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Displays a snackbar using Flutter's native SnackBar
/// Note: Requires BuildContext - use showToast for context-free messages
///
/// Parameters:
/// - [context]: BuildContext for showing the snackbar
/// - [title]: The title of the snackbar
/// - [message]: The message content of the snackbar
/// - [type]: Type of snackbar (success, error, info, warning)
/// - [duration]: How long to show the snackbar
void showSnackBar(
  BuildContext context, {
  required String title,
  required String message,
  SnackBarType? type,
  Duration duration = const Duration(seconds: 3),
}) {
  IconData? iconData;
  Color? iconColor;
  final colorScheme = Theme.of(context).colorScheme;

  if (type != null) {
    switch (type) {
      case SnackBarType.success:
        iconData = Icons.check_circle_rounded;
        iconColor = colorScheme.primary;
        break;
      case SnackBarType.error:
        iconData = Icons.cancel_rounded;
        iconColor = colorScheme.error;
        break;
      case SnackBarType.info:
        iconData = Icons.info_rounded;
        iconColor = colorScheme.tertiary;
        break;
      case SnackBarType.warning:
        iconData = Icons.warning_rounded;
        iconColor = Colors.orange;
        break;
    }
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (iconData != null)
            Icon(iconData, color: iconColor ?? colorScheme.onSurface),
          if (iconData != null) const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(message),
              ],
            ),
          ),
        ],
      ),
      duration: duration,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

/// Displays a toast message.
///
/// The toast will display the provided [title] and [message].
/// The toast is displayed on Android, iOS, and Web platforms.
///
/// Parameters:
/// - [title]: The title of the toast.
/// - [message]: The message content of the toast.
void showToast({String? title, required String message}) {
  Fluttertoast.showToast(
    msg: "${title == null ? "" : "$title: "}$message",
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
  );
}

/// Displays a confirmation dialog
///
/// Returns `true` if confirmed, `false` if cancelled
///
/// Parameters:
/// - [context]: BuildContext for showing the dialog
/// - [heading]: The title of the dialog
/// - [message]: The message content
Future<bool> showConfirmationMessage(
  BuildContext context, {
  required String heading,
  required String message,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(heading),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Confirm'),
        ),
      ],
    ),
  );
  
  return result ?? false;
}

/// Snack bar Status
enum SnackBarType {
  /// For success
  success,

  /// For error
  error,

  /// For info
  info,

  /// For warning
  warning,
}

