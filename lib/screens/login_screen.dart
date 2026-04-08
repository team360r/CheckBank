import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';

/// Login screen with intentional accessibility bugs.
///
/// BUG 1: TextFields use `hintText` only — screen readers don't announce a
///        persistent label once the user starts typing.
/// BUG 2: Submit button says "Go" with no Semantics label describing the action.
/// BUG 3: Error message is NOT in a live region — screen readers won't
///        automatically announce it when it appears.
/// BUG 4: "Forgot password?" is a GestureDetector with no minimum touch target
///        (< 48 dp) and no semantic role.
/// BUG 5: "Forgot password?" uses AppColors.textSecondary — fails WCAG AA
///        contrast.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    ref
        .read(authProvider.notifier)
        .login(_emailController.text, _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo / branding
                Icon(
                  Icons.account_balance,
                  size: 64,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  'CheckBank',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to your account',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        // BUG 5: Low-contrast secondary text
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 40),

                // BUG 1: hintText only — no labelText for screen readers
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email address',
                  ),
                ),
                const SizedBox(height: 16),

                // BUG 1: hintText only — no labelText for screen readers
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                const SizedBox(height: 8),

                // BUG 3: Error text is NOT wrapped in a live region
                if (auth.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      auth.error!,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),

                const SizedBox(height: 16),

                // BUG 2: Button label is vague ("Go") and has no semantic label
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Go'),
                  ),
                ),

                const SizedBox(height: 24),

                // BUG 4: GestureDetector with no minimum touch target (< 48 dp)
                // BUG 5: Low-contrast text colour
                GestureDetector(
                  onTap: () {
                    // no-op for demo
                  },
                  child: Text(
                    'Forgot password?',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
