import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mytest_project/core/di/injection_container.dart';
import 'package:mytest_project/features/risk_settings/presentation/bloc/risk_settings_bloc.dart';

class RiskSettingsPage extends StatelessWidget {
  const RiskSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<RiskSettingsBloc>()
        ..add(
          RiskSettingsLoadRequested(),
        ),
      child: const _RiskSettingsView(),
    );
  }
}

class _RiskSettingsView extends StatefulWidget {
  const _RiskSettingsView();

  @override
  State<_RiskSettingsView> createState() =>
      _RiskSettingsViewState();
}

class _RiskSettingsViewState
    extends State<_RiskSettingsView> {
  final _formKey = GlobalKey<FormState>();

  final _riskPerTradeController =
      TextEditingController();

  final _dailyLossLimitController =
      TextEditingController();

  final _maxDrawdownController =
      TextEditingController();

  bool _valuesLoaded = false;

  @override
  void dispose() {
    _riskPerTradeController.dispose();
    _dailyLossLimitController.dispose();
    _maxDrawdownController.dispose();

    super.dispose();
  }

  void _loadValues(
    RiskSettingsLoaded state,
  ) {
    if (_valuesLoaded) {
      return;
    }

    _riskPerTradeController.text =
        state.settings.riskPerTrade.toStringAsFixed(1);

    _dailyLossLimitController.text =
        state.settings.dailyLossLimit.toStringAsFixed(1);

    _maxDrawdownController.text =
        state.settings.maxDrawdown.toStringAsFixed(1);

    _valuesLoaded = true;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final riskPerTrade = double.parse(
      _riskPerTradeController.text.trim(),
    );

    final dailyLossLimit = double.parse(
      _dailyLossLimitController.text.trim(),
    );

    final maxDrawdown = double.parse(
      _maxDrawdownController.text.trim(),
    );

    context.read<RiskSettingsBloc>().add(
          RiskSettingsUpdateRequested(
            riskPerTrade: riskPerTrade,
            dailyLossLimit: dailyLossLimit,
            maxDrawdown: maxDrawdown,
          ),
        );
  }

  String? _validatePercentage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    final number = double.tryParse(
      value.trim(),
    );

    if (number == null) {
      return 'Enter a valid number';
    }

    if (number < 0.01 || number > 100) {
      return 'Enter a value between 0.01 and 100';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Risk Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<
          RiskSettingsBloc,
          RiskSettingsState>(
        listener: (context, state) {
          if (state is RiskSettingsUpdated) {
            _riskPerTradeController.text =
                state.settings.riskPerTrade
                    .toStringAsFixed(1);

            _dailyLossLimitController.text =
                state.settings.dailyLossLimit
                    .toStringAsFixed(1);

            _maxDrawdownController.text =
                state.settings.maxDrawdown
                    .toStringAsFixed(1);

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text(
                    'Risk settings updated successfully.',
                  ),
                ),
              );
          }

          if (state is RiskSettingsFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state is RiskSettingsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is RiskSettingsLoaded) {
            _loadValues(state);
          }

          final isUpdating =
              state is RiskSettingsUpdating;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Risk Management',
                      style: theme
                          .textTheme.headlineSmall
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Set limits that help you manage trading risk and protect your account.',
                      style:
                          theme.textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 32),

                    _RiskField(
                      controller:
                          _riskPerTradeController,
                      title: 'Risk Per Trade',
                      description:
                          'Maximum percentage of your account to risk on a single trade.',
                      validator:
                          _validatePercentage,
                    ),

                    const SizedBox(height: 24),

                    _RiskField(
                      controller:
                          _dailyLossLimitController,
                      title: 'Daily Loss Limit',
                      description:
                          'Maximum percentage loss allowed for one trading day.',
                      validator:
                          _validatePercentage,
                    ),

                    const SizedBox(height: 24),

                    _RiskField(
                      controller:
                          _maxDrawdownController,
                      title: 'Maximum Drawdown',
                      description:
                          'Maximum account drawdown you are willing to allow.',
                      validator:
                          _validatePercentage,
                    ),

                    const SizedBox(height: 36),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed:
                            isUpdating ? null : _save,
                        icon: isUpdating
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.save_outlined,
                              ),
                        label: Text(
                          isUpdating
                              ? 'Saving...'
                              : 'Save Risk Settings',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RiskField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String description;
  final String? Function(String?) validator;

  const _RiskField({
    required this.controller,
    required this.title,
    required this.description,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          description,
          style: theme.textTheme.bodySmall,
        ),

        const SizedBox(height: 10),

        TextFormField(
          controller: controller,
          keyboardType:
              const TextInputType.numberWithOptions(
            decimal: true,
          ),
          validator: validator,
          decoration: const InputDecoration(
            suffixText: '%',
            hintText: '0.0',
          ),
        ),
      ],
    );
  }
}