import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mytest_project/core/di/injection_container.dart';
import 'package:mytest_project/features/settings/presentation/bloc/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
    serviceLocator<SettingsBloc>()
      ..add(const SettingsLoadRequested()),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trading Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading || state is SettingsInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is SettingsFailure) {
            return Center(
              child: Text(state.message),
            );
          }

         if (state is SettingsLoaded) {
          return _SettingsForm(
          state: state,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
class _SettingsForm extends StatelessWidget {
  final SettingsLoaded state;

  const _SettingsForm({
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final settings = state.settings;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Trading Preferences',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 30),

          // ==============================
          // Currency
          // ==============================

          DropdownButtonFormField<String>(
            initialValue: settings.currencyCode,
            decoration: const InputDecoration(
              labelText: 'Currency',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 'GBP',
                child: Text('GBP (£)'),
              ),
              DropdownMenuItem(
                value: 'USD',
                child: Text('USD (\$)'),
              ),
              DropdownMenuItem(
                value: 'EUR',
                child: Text('EUR (€)'),
              ),
              DropdownMenuItem(
                value: 'NGN',
                child: Text('NGN (₦)'),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;

              final symbol = switch (value) {
                'GBP' => '£',
                'USD' => '\$',
                'EUR' => '€',
                'NGN' => '₦',
                _ => '£',
              };

              context.read<SettingsBloc>().add(
                SettingsCurrencyChanged(
                  currencyCode: value,
                  currencySymbol: symbol,
                ),
              );
            },
          ),

          const SizedBox(height: 25),

          // ==============================
          // Decimal Places
          // ==============================

          DropdownButtonFormField<int>(
          initialValue: settings.decimalPlaces,
            decoration: const InputDecoration(
              labelText: 'Decimal Places',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 2,
                child: Text('2'),
              ),
              DropdownMenuItem(
                value: 3,
                child: Text('3'),
              ),
              DropdownMenuItem(
                value: 4,
                child: Text('4'),
              ),
              DropdownMenuItem(
                value: 5,
                child: Text('5'),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;

              context.read<SettingsBloc>().add(
                SettingsDecimalPlacesChanged(
                  decimalPlaces: value,
                ),
              );
            },
          ),

          const Spacer(),

          SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text(
                'Save Settings',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                context.read<SettingsBloc>().add(
                  const SettingsSaveRequested(),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Trading settings saved.',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}