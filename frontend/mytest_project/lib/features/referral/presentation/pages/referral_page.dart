import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';

import '../bloc/referral_bloc.dart';
import '../bloc/referral_event.dart';
import '../bloc/referral_state.dart';

class ReferralPage extends StatelessWidget {
  const ReferralPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<ReferralBloc>()
        ..add(const ReferralLoadRequested()),
      child: const _ReferralView(),
    );
  }
}

class _ReferralView extends StatelessWidget {
  const _ReferralView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Referrals'),
      ),
      body: BlocBuilder<ReferralBloc, ReferralState>(
        builder: (context, state) {
          if (state is ReferralLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ReferralFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ReferralBloc>().add(
                              const ReferralLoadRequested(),
                            );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ReferralLoaded) {
            final summary = state.summary;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ReferralBloc>().add(
                      const ReferralLoadRequested(),
                    );
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Invite friends and earn rewards',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Share your referral code with friends. '
                    'When they subscribe to a paid plan, '
                    'your referral can become qualified.',
                  ),

                  const SizedBox(height: 24),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'Your Referral Code',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              SelectableText(
                                summary.referralCode,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text:
                                          summary.referralCode,
                                    ),
                                  );

                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Referral code copied',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _StatCard(
                        title: 'Total',
                        value:
                            '${summary.totalReferrals}',
                      ),
                      _StatCard(
                        title: 'Pending',
                        value: '${summary.pending}',
                      ),
                      _StatCard(
                        title: 'Qualified',
                        value: '${summary.qualified}',
                      ),
                      _StatCard(
                        title: 'Rewarded',
                        value: '${summary.rewarded}',
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.account_balance_wallet,
                      ),
                      title: const Text('Total Rewards'),
                      subtitle: Text(
                        summary.rewardCurrency,
                      ),
                      trailing: Text(
                        '${summary.rewardCurrency} '
                        '${summary.totalRewards.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Referral History',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (state.referrals.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            'No referrals yet.',
                          ),
                        ),
                      ),
                    ),

                  ...state.referrals.map(
                    (referral) => Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            referral.referredUser?.name
                                    .substring(0, 1)
                                    .toUpperCase() ??
                                '?',
                          ),
                        ),
                        title: Text(
                          referral.referredUser?.name ??
                              'Unknown user',
                        ),
                        subtitle: Text(
                          referral.status.toUpperCase(),
                        ),
                        trailing:
                            referral.rewardAmount > 0
                                ? Text(
                                    '${referral.rewardCurrency} '
                                    '${referral.rewardAmount.toStringAsFixed(2)}',
                                  )
                                : null,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(title),
          ],
        ),
      ),
    );
  }
}