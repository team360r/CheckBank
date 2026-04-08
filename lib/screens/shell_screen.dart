import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/notifications_provider.dart';

class ShellScreen extends ConsumerWidget {
  final Widget child;
  const ShellScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadCountProvider);
    final location = GoRouterState.of(context).matchedLocation;

    int currentIndex;
    if (location.startsWith('/dashboard') ||
        location.startsWith('/transactions')) {
      currentIndex = 0;
    } else if (location.startsWith('/transfer')) {
      currentIndex = 1;
    } else if (location.startsWith('/notifications')) {
      currentIndex = 2;
    } else if (location.startsWith('/settings')) {
      currentIndex = 3;
    } else {
      currentIndex = 0;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/dashboard');
            case 1:
              context.go('/transfer');
            case 2:
              context.go('/notifications');
            case 3:
              context.go('/settings');
          }
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Accounts',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.send),
            label: 'Transfer',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: unread > 0,
              label: Text('$unread'),
              child: const Icon(Icons.notifications),
            ),
            label: 'Alerts',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
