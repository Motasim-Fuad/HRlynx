import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/chat/sessionHistoryModel.dart';

class SessionHistoryTile extends StatelessWidget {
  final SessionHistory session;
  final String personaAvatar;
  final VoidCallback onTap;

  const SessionHistoryTile({
    required this.session,
    required this.personaAvatar,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(personaAvatar),
      ),
      title: Text(
        session.title,
        style: TextStyle(color: Colors.white),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
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