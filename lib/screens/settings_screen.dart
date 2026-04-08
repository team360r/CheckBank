import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_data.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';

/// Settings screen with intentional accessibility bugs.
///
/// BUG 1: Toggle switches use ListTile + trailing Switch instead of
///        SwitchListTile — toggle value state is not linked to the title
///        in semantics.
/// BUG 2: Text scaling breaks layout at 200% — user info row uses a Column
///        inside a fixed-height container without Flexible.
/// BUG 3: No explicit focus traversal order set.
/// BUG 4: "About CheckBank" label uses AppColors.textDisabled — extremely
///        low contrast (ratio ~1.9:1).
/// BUG 5: Subtitles use AppColors.textSecondary — fails WCAG AA contrast.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _biometrics = false;
  bool _notifications = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // BUG 2: Fixed-height container with Column — breaks at 200% text
          Container(
            height: 100,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    mockUser.name[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // BUG 2: Column without Flexible — overflows at large text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      mockUser.name,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    const SizedBox(height: 4),
                    // BUG 5: Low-contrast secondary text
                    Text(
                      mockUser.email,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),

          // BUG 1: ListTile + trailing Switch — toggle state not linked to title
          // BUG 3: No explicit focus traversal order
          ListTile(
            title: const Text('Biometric login'),
            subtitle: Text(
              'Use fingerprint or face to sign in',
              // BUG 5: Low-contrast subtitle
              style: TextStyle(color: AppColors.textSecondary),
            ),
            trailing: Switch(
              value: _biometrics,
              onChanged: (v) => setState(() => _biometrics = v),
            ),
          ),
          ListTile(
            title: const Text('Push notifications'),
            subtitle: Text(
              'Receive alerts for account activity',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            trailing: Switch(
              value: _notifications,
              onChanged: (v) => setState(() => _notifications = v),
            ),
          ),
          ListTile(
            title: const Text('Dark mode'),
            subtitle: Text(
              'Switch to dark theme',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            trailing: Switch(
              value: _darkMode,
              onChanged: (v) => setState(() => _darkMode = v),
            ),
          ),

          const Divider(),

          // BUG 4: Extremely low-contrast text (textDisabled)
          ListTile(
            title: Text(
              'About CheckBank',
              style: TextStyle(color: AppColors.textDisabled),
            ),
            trailing:
                const Icon(Icons.chevron_right, color: AppColors.textDisabled),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'CheckBank',
                applicationVersion: '1.0.0',
                applicationLegalese: 'A demo banking app for accessibility testing.',
              );
            },
          ),

          const SizedBox(height: 24),

          // Sign out button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton(
              onPressed: () {
                ref.read(authProvider.notifier).logout();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Sign out'),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
