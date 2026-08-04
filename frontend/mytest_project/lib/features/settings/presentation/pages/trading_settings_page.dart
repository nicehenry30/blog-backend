
import 'package:flutter/material.dart';

import 'package:mytest_project/features/settings/data/repository/trading_settings_repository_impl.dart';
import 'package:mytest_project/features/settings/domain/entities/trading_settings.dart';

class TradingSettingsPage extends StatefulWidget {
  final TradingSettingsRepositoryImpl repository;

  const TradingSettingsPage({
    super.key,
    required this.repository,
  });

  @override
  State<TradingSettingsPage> createState() => _TradingSettingsPageState();
}

class _TradingSettingsPageState extends State<TradingSettingsPage> {
  late TradingSettings _settings;

  bool _isLoading = true;
  bool _isSaving = false;

  final List<Map<String, String>> _currencies = const [
    {
      'code': 'USD',
      'symbol': '\$',
      'name': 'US Dollar',
    },
    {
      'code': 'GBP',
      'symbol': '£',
      'name': 'British Pound',
    },
    {
      'code': 'EUR',
      'symbol': '€',
      'name': 'Euro',
    },
    {
      'code': 'NGN',
      'symbol': '₦',
      'name': 'Nigerian Naira',
    },
    {
      'code': 'JPY',
      'symbol': '¥',
      'name': 'Japanese Yen',
    },
    {
      'code': 'AUD',
      'symbol': 'A\$',
      'name': 'Australian Dollar',
    },
    {
      'code': 'CAD',
      'symbol': 'C\$',
      'name': 'Canadian Dollar',
    },
    {
      'code': 'CHF',
      'symbol': 'CHF',
      'name': 'Swiss Franc',
    },
  ];

  @override
  void initState() {
    super.initState();

    _settings = const TradingSettings.defaultSettings();

    _loadSettings();
  }

  void _loadSettings() {
    final savedSettings = widget.repository.getSettings();

    if (!mounted) {
      return;
    }

    setState(() {
      _settings = savedSettings;
      _isLoading = false;
    });
  }

  Future<void> _selectCurrency() async {
    final selectedCurrency = await showModalBottomSheet<Map<String, String>>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Select Account Currency',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ..._currencies.map(
                (currency) {
                  final isSelected =
                      currency['code'] == _settings.currencyCode;

                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        currency['symbol']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      currency['name']!,
                    ),
                    subtitle: Text(
                      currency['code']!,
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      Navigator.pop(
                        context,
                        currency,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );

    if (selectedCurrency == null || !mounted) {
      return;
    }

    setState(() {
      _settings = _settings.copyWith(
        currencyCode: selectedCurrency['code'],
        currencySymbol: selectedCurrency['symbol'],
      );
    });
  }

  Future<void> _selectDecimalPlaces() async {
    final selectedDecimalPlaces =
        await showModalBottomSheet<int>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select Price Decimal Places',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ...[2, 3, 4, 5].map(
                (decimalPlaces) {
                  final isSelected =
                      decimalPlaces == _settings.decimalPlaces;

                  return ListTile(
                    leading: const Icon(
                      Icons.numbers,
                    ),
                    title: Text(
                      '$decimalPlaces Decimal Places',
                    ),
                    subtitle: Text(
                      'Example: '
                      '${1.234567.toStringAsFixed(decimalPlaces)}',
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      Navigator.pop(
                        context,
                        decimalPlaces,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );

    if (selectedDecimalPlaces == null || !mounted) {
      return;
    }

    setState(() {
      _settings = _settings.copyWith(
        decimalPlaces: selectedDecimalPlaces,
      );
    });
  }

  Future<void> _saveSettings() async {
    setState(() {
      _isSaving = true;
    });

    try {
      await widget.repository.saveSettings(_settings);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Trading settings saved successfully.',
          ),
        ),
      );

      Navigator.pop(
        context,
        _settings,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to save settings: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trading Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Account & Display',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Choose how monetary values and prices are displayed '
            'in your trading journal.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 20),

          // ================================================================
          // ACCOUNT CURRENCY
          // ================================================================

          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(
                  Icons.currency_exchange,
                ),
              ),
              title: const Text(
                'Account Currency',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${_settings.currencyCode} '
                '(${_settings.currencySymbol})',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: _selectCurrency,
            ),
          ),

          const SizedBox(height: 12),

          // ================================================================
          // DECIMAL PLACES
          // ================================================================

          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(
                  Icons.numbers,
                ),
              ),
              title: const Text(
                'Price Decimal Places',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${_settings.decimalPlaces} decimal places',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: _selectDecimalPlaces,
            ),
          ),

          const SizedBox(height: 24),

          // ================================================================
          // PREVIEW
          // ================================================================

          Text(
            'Preview',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _PreviewRow(
                    label: 'Entry Price',
                    value: 1.12345678
                        .toStringAsFixed(_settings.decimalPlaces),
                  ),

                  const Divider(height: 24),

                  _PreviewRow(
                    label: 'Exit Price',
                    value: 1.12567891
                        .toStringAsFixed(_settings.decimalPlaces),
                  ),

                  const Divider(height: 24),

                  _PreviewRow(
                    label: 'Profit / Loss',
                    value: '${_settings.currencySymbol}50.00',
                    valueColor: Colors.green,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // ================================================================
          // SAVE BUTTON
          // ================================================================

          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _saveSettings,
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      Icons.save_outlined,
                    ),
              label: Text(
                _isSaving
                    ? 'Saving...'
                    : 'Save Settings',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PREVIEW ROW
// ============================================================================

class _PreviewRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _PreviewRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

