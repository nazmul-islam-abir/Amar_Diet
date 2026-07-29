import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';
import '../services/bdapps_service.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: AppColors.textPrimary,
                    ),
                    const Spacer(),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 44),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.md,
                    AppSpacing.xl,
                    120,
                  ),
                  children: [
                    _Section(title: 'Account', items: [
                      _Item(icon: Icons.person_outline_rounded, label: 'Personal info', trailing: 'Edit'),
                      _Item(icon: Icons.lock_outline_rounded, label: 'Password & security'),
                      _Item(icon: Icons.email_outlined, label: 'Email', trailing: 'Verified'),
                    ]),
                    const SizedBox(height: AppSpacing.lg),
                    _Section(title: 'Preferences', items: [
                      _Item(icon: Icons.language_rounded, label: 'Language', trailing: 'English'),
                      _Item(
                        icon: Icons.dark_mode_outlined,
                        label: 'Dark mode',
                        trailing: const _Toggle(),
                      ),
                      _Item(
                        icon: Icons.notifications_outlined,
                        label: 'Notifications',
                        trailing: const _Toggle(value: true),
                      ),
                    ]),
                    const SizedBox(height: AppSpacing.lg),
                    _Section(title: 'Diet & health', items: [
                      _Item(icon: Icons.restaurant_outlined, label: 'Diet preferences', trailing: 'Non-veg'),
                      _Item(icon: Icons.warning_amber_rounded, label: 'Allergies'),
                      _Item(icon: Icons.flag_outlined, label: 'Health goal', trailing: 'Maintain'),
                    ]),
                    const SizedBox(height: AppSpacing.lg),
                    _Section(title: 'Support', items: [
                      _Item(icon: Icons.help_outline_rounded, label: 'Help center'),
                      _Item(icon: Icons.privacy_tip_outlined, label: 'Privacy policy'),
                      _Item(
                        icon: Icons.block_rounded,
                        label: 'Unsubscribe',
                        tint: AppColors.secondary,
                        onTap: () => _confirmUnsubscribe(context),
                      ),
                      _Item(
                        icon: Icons.logout_rounded,
                        label: 'Log out',
                        tint: AppColors.secondary,
                        onTap: () => _onLogout(context),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: const Text('Log out?'),
        content: const Text('You will need to sign in again to access your data.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.secondary),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await AuthService.instance.signOut();
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _confirmUnsubscribe(BuildContext context) async {
    final phone = AuthService.instance.phone;
    if (phone == null || phone.isEmpty) {
      _snack(context, 'No active session to unsubscribe');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: const Text('Unsubscribe?'),
        content: const Text(
          'You will lose access to Amar Diet until you subscribe again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.secondary),
            child: const Text('Unsubscribe'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final res = await BdappsService.unsubscribe(phone);
    final success = (res['ok'] == true) ||
        (res['success'] == true) ||
        (res['subscriptionStatus']?.toString().toUpperCase() == 'UNREGISTERED');

    if (!context.mounted) return;
    Navigator.pop(context); // dismiss loader

    if (!success) {
      _snack(
        context,
        res['statusDetail']?.toString() ??
            res['error']?.toString() ??
            'Could not unsubscribe. Try again.',
      );
      return;
    }

    await AuthService.instance.signOut();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.items});
  final String title;
  final List<_Item> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
              letterSpacing: 0.4,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                items[i],
                if (i != items.length - 1)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Divider(height: 1, color: Color(0x14000000)),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.icon,
    required this.label,
    this.trailing,
    this.tint,
    this.onTap,
  });
  final IconData icon;
  final String label;
  final dynamic trailing;
  final Color? tint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = tint ?? AppColors.primaryDark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 14,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: c.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, color: c, size: 18),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: tint ?? AppColors.textPrimary,
                  ),
                ),
              ),
              if (trailing is Widget)
                trailing as Widget
              else if (trailing is String)
                Text(
                  trailing as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                )
              else
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle({this.value = false});
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: value,
      activeColor: AppColors.primary,
      onChanged: (_) {},
    );
  }
}
