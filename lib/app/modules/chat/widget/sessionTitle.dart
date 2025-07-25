import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/chat/sessionHistoryModel.dart';

class SessionHistoryTile extends StatelessWidget {
  final SessionHistory session;
  final VoidCallback onTap;
  final VoidCallback? onDelete; // Add delete callback

  const SessionHistoryTile({
    required this.session,
    required this.onTap,
    this.onDelete, // Optional delete callback
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('session_${session.id}'), // Unique key for each session
      direction: DismissDirection.endToStart, // Swipe from right to left
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 28,
        ),
      ),
      confirmDismiss: (direction) async {
        // Show confirmation dialog
        return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Delete Chat'),
              content: Text('Are you sure you want to delete this chat session? This action cannot be undone.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: Text('Delete'),
                ),
              ],
            );
          },
        ) ?? false; // Return false if dialog is dismissed
      },
      onDismissed: (direction) {
        // Call the delete callback if provided
        if (onDelete != null) {
          onDelete!();
        }
      },
      child: ListTile(
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (session.lastMessage != null)
              Text(
                session.lastMessage!.content,
                style: TextStyle(color: Colors.white70),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            Text(
              '${session.messageCount} messages • ${formatDate(session.updatedAt)}',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
        onTap: onTap,
        trailing: Icon(
          Icons.swipe_left,
          color: Colors.white54,
          size: 16,
        ), // Visual hint for swipe action
      ),
    );
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return DateFormat('MMM d, y').format(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}