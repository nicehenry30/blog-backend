import 'package:flutter/material.dart';
import 'package:mytest_project/features/subscription/presentation/pages/subscription_page.dart';
import 'package:mytest_project/features/education/presentation/pages/education_page.dart';
import 'package:mytest_project/features/guardian/presentation/pages/guardian_page.dart';
import 'package:mytest_project/features/risk_settings/presentation/pages/risk_settings_page.dart';
import 'package:mytest_project/features/news/presentation/pages/news_page.dart';
import 'package:mytest_project/features/profile/presentation/pages/profile_page.dart';
import 'package:mytest_project/features/settings/presentation/pages/settings_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Learning'),

          _buildMenuItem(
            context,
            icon: Icons.school_outlined,
            title: 'Education',
            subtitle: 'Learn trading and improve your skills',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EducationPage()),
              );
            },
          ),

          const SizedBox(height: 16),

          _buildSectionTitle('Trading Tools'),

          _buildMenuItem(
            context,
            icon: Icons.shield_outlined,
            title: 'Guardian',
            subtitle: 'Protect your trading account',
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                showDragHandle: true,
                builder: (sheetContext) {
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Choose Guardian',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.shield_outlined),
                            title: const Text('MT4 Guardian'),
                            subtitle: const Text(
                              'Protect your MT4 trading account',
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.pop(sheetContext);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const GuardianPage(platform: 'MT4'),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.shield_outlined),
                            title: const Text('MT5 Guardian'),
                            subtitle: const Text(
                              'Protect your MT5 trading account',
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.pop(sheetContext);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const GuardianPage(platform: 'MT5'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          _buildMenuItem(
            context,
            icon: Icons.security_outlined,
            title: 'Risk Settings',
            subtitle: 'Manage your trading risk preferences',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RiskSettingsPage()),
              );
            },
          ),

          _buildMenuItem(
            context,
            icon: Icons.newspaper_outlined,
            title: 'News',
            subtitle: 'Stay informed about the markets',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NewsPage()),
              );
            },
          ),

          const SizedBox(height: 16),

          _buildSectionTitle('Account'),

          _buildMenuItem(
            context,
            icon: Icons.workspace_premium_outlined,
            title: 'Subscription',
            subtitle: 'Manage your Tradewisser plan',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SubscriptionPage()),
              );
            },
          ),

          _buildMenuItem(
            context,
            icon: Icons.person_outline,
            title: 'Profile',
            subtitle: 'Manage your account',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),

          _buildMenuItem(
            context,
            icon: Icons.settings_outlined,
            title: 'Settings',
            subtitle: 'Manage application settings',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
