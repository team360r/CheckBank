import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/notifications_provider.dart';
import '../theme/app_colors.dart';

/// Notifications screen with intentional accessibility bugs.
///
/// BUG 1: Unread count text is NOT in a live region — won't announce when
///        it changes.
/// BUG 2: "Mark all read" button in AppBar is NOT exposed as a
///        CustomSemanticsAction.
/// BUG 3: Notification read/unread state is not conveyed in semantics — the
///        visual bold/normal weight difference is invisible to screen readers.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final unread = ref.watch(unreadCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          // BUG 2: IconButton in AppBar — no CustomSemanticsAction, just
          // a plain icon button that screen readers won't associate with
          // "mark all read"
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              ref.read(notificationsProvider.notifier).markAllRead();
            },
            tooltip: 'Mark all read',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BUG 1: Unread count NOT in a live region
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              '$unread unread',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Expanded(
            child: notifications.isEmpty
                ? const Center(child: Text('No notifications'))
                : ListView.separated(
                    itemCount: notifications.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final notif = notifications[index];
                      final timeText = DateFormat('d MMM, HH:mm')
                          .format(notif.timestamp);

                      // BUG 3: Read/unread state not in semantics — only
                      // conveyed by visual weight difference
                      return ListTile(
                        leading: Icon(
                          notif.read
                              ? Icons.notifications_none
                              : Icons.notifications_active,
                          color: notif.read
                              ? AppColors.textSecondary
                              : AppColors.primary,
                        ),
                        title: Text(
                          notif.title,
                          style: TextStyle(
                            fontWeight:
                                notif.read ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          notif.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          timeText,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        onTap: () {
                          ref
                              .read(notificationsProvider.notifier)
                              .markRead(notif.id);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
