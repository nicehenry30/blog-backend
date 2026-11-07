import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mytest_project/core/di/injection_container.dart';

import '../../../referral/presentation/pages/referral_page.dart';

import '../../../referral/presentation/bloc/referral_bloc.dart';
import '../../../referral/presentation/bloc/referral_event.dart';

import 'package:mytest_project/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:mytest_project/features/profile/presentation/pages/edit_profile_page.dart';

import 'package:mytest_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mytest_project/features/settings/presentation/pages/settings_page.dart';

import 'package:mytest_project/features/guardian/presentation/bloc/guardian_bloc.dart';
import 'package:mytest_project/features/guardian/presentation/pages/guardian_page.dart';
import 'package:mytest_project/features/feedback/presentation/bloc/feedback_bloc.dart';
import 'package:mytest_project/features/feedback/presentation/pages/feedback_page.dart';
import 'package:mytest_project/features/subscription/presentation/pages/subscription_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 50),
                    const SizedBox(height: 12),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(LoadProfile());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ProfileLoaded) {
            final profile = state.profile;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(LoadProfile());
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  // ==========================================================
                  // PROFILE HEADER
                  // ==========================================================
                  _ProfileHeader(name: profile.name, email: profile.email),

                  const SizedBox(height: 20),

                  // ==========================================================
                  // PROFILE INFORMATION
                  // ==========================================================
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person_outline),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'Personal Information',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Edit Profile',
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<ProfileBloc>(),
                                        child: EditProfilePage(
                                          profile: profile,
                                        ),
                                      ),
                                    ),
                                  );

                                  if (!context.mounted) return;

                                  context.read<ProfileBloc>().add(
                                    LoadProfile(),
                                  );
                                },
                              ),
                            ],
                          ),

                          const Divider(height: 24),

                          _InfoRow(
                            icon: Icons.person_outline,
                            label: 'Name',
                            value: profile.name,
                          ),

                          const SizedBox(height: 14),

                          _InfoRow(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: profile.email,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ==========================================================
                  // GUARDIAN
                  // ==========================================================
                  const Text(
                    'Guardian',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  // -------------------- MT4 --------------------
                  _GuardianCard(
                    title: 'MT4 Guardian',
                    platform: 'MT4',
                    connected: profile.mt4Connected,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) =>
                                serviceLocator<GuardianBloc>()
                                  ..add(GuardianLoadRequested(platform: 'MT4')),
                            child: const GuardianPage(platform: 'MT4'),
                          ),
                        ),
                      );

                      if (!context.mounted) return;

                      context.read<ProfileBloc>().add(LoadProfile());
                    },
                  ),

                  const SizedBox(height: 12),

                  // -------------------- MT5 --------------------
                  _GuardianCard(
                    title: 'MT5 Guardian',
                    platform: 'MT5',
                    connected: profile.mt5Connected,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) =>
                                serviceLocator<GuardianBloc>()
                                  ..add(GuardianLoadRequested(platform: 'MT5')),
                            child: const GuardianPage(platform: 'MT5'),
                          ),
                        ),
                      );

                      if (!context.mounted) return;

                      context.read<ProfileBloc>().add(LoadProfile());
                    },
                  ),

                  const SizedBox(height: 24),

                  // ==========================================================
                  // ACCOUNT
                  // ==========================================================
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.workspace_premium_outlined),
                          title: const Text('Subscription / Plans'),
                          subtitle: const Text(
                            'Manage your plan and subscription',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SubscriptionPage(),
                              ),
                            );
                          },
                        ),

                        // ======================================================
                        // SETTINGS
                        // ======================================================
                        ListTile(
                          leading: const Icon(Icons.settings_outlined),
                          title: const Text('Settings'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SettingsPage(),
                              ),
                            );
                          },
                        ),

                        const Divider(height: 1),

                        // ======================================================
                        // REFER & EARN
                        // ======================================================
                        ListTile(
                          leading: const Icon(Icons.card_giftcard_outlined),
                          title: const Text('Refer & Earn'),
                          subtitle: const Text(
                            'Invite friends and earn rewards',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (_) =>
                                      serviceLocator<ReferralBloc>()
                                        ..add(const ReferralLoadRequested()),
                                  child: const ReferralPage(),
                                ),
                              ),
                            );
                          },
                        ),

                        // ======================================================
                        // FEEDBACK
                        // ======================================================
                        ListTile(
                          leading: const Icon(Icons.feedback_outlined),
                          title: const Text('Feedback'),
                          subtitle: const Text(
                            'Send feedback or contact support',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (_) =>
                                      serviceLocator<FeedbackBloc>()
                                        ..add(const LoadFeedback()),
                                  child: const FeedbackPage(),
                                ),
                              ),
                            );
                          },
                        ),

                        const Divider(height: 1),

                        // ======================================================
                        // LOGOUT
                        // ======================================================
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('Logout'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            final shouldLogout = await showDialog<bool>(
                              context: context,
                              builder: (dialogContext) {
                                return AlertDialog(
                                  title: const Text('Logout'),
                                  content: const Text(
                                    'Are you sure you want to logout?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(dialogContext, false);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(dialogContext, true);
                                      },
                                      child: const Text('Logout'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (!context.mounted || shouldLogout != true) {
                              return;
                            }

                            context.read<AuthBloc>().add(const AuthLogOut());
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

// ============================================================================
// PROFILE HEADER
// ============================================================================

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;

  const _ProfileHeader({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 34,
              child: Text(
                name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// INFORMATION ROW
// ============================================================================

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 21, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// GUARDIAN CARD
// ============================================================================

class _GuardianCard extends StatelessWidget {
  final String title;
  final String platform;
  final bool connected;
  final VoidCallback onTap;

  const _GuardianCard({
    required this.title,
    required this.platform,
    required this.connected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // GREEN = CONNECTED
    // RED   = DISCONNECTED
    final statusColor = connected ? Colors.green : Colors.red;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              // Guardian icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.shield_outlined,
                  color: statusColor,
                  size: 27,
                ),
              ),

              const SizedBox(width: 14),

              // Title + status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          connected ? Icons.check_circle : Icons.cancel,
                          size: 15,
                          color: statusColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          connected
                              ? '$platform Connected'
                              : '$platform Disconnected',
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
