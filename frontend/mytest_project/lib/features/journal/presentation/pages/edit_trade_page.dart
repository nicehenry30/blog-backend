
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mytest_project/features/journal/domain/entities/trade.dart';
import 'package:mytest_project/features/journal/presentation/bloc/journal_bloc.dart';

class EditTradePage extends StatefulWidget {
  final Trade trade;
  final JournalBloc journalBloc;

  const EditTradePage({
    super.key,
    required this.trade,
    required this.journalBloc,
  });

  @override
  State<EditTradePage> createState() => _EditTradePageState();
}

class _EditTradePageState extends State<EditTradePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _symbolController;
  late final TextEditingController _entryController;
  late final TextEditingController _exitController;
  late final TextEditingController _profitLossController;
  late final TextEditingController _notesController;

  late String _direction;
  late String _result;

  @override
  void initState() {
    super.initState();

    _symbolController = TextEditingController(
      text: widget.trade.symbol,
    );

    _entryController = TextEditingController(
      text: widget.trade.entry.toString(),
    );

    _exitController = TextEditingController(
      text: widget.trade.exit.toString(),
    );

    _profitLossController = TextEditingController(
      text: widget.trade.profitLoss.toString(),
    );

    _notesController = TextEditingController(
      text: widget.trade.notes,
    );

    _direction = widget.trade.direction;
    _result = widget.trade.result;
  }

  @override
  void dispose() {
    _symbolController.dispose();
    _entryController.dispose();
    _exitController.dispose();
    _profitLossController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  // ==========================================================================
  // SUBMIT UPDATED TRADE
  // ==========================================================================

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final entry = double.tryParse(
      _entryController.text.trim(),
    );

    final exit = double.tryParse(
      _exitController.text.trim(),
    );

    final profitLoss = double.tryParse(
      _profitLossController.text.trim(),
    );

    if (entry == null || exit == null || profitLoss == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter valid numerical values.',
          ),
        ),
      );

      return;
    }

    final updatedTrade = Trade(
      id: widget.trade.id,
      symbol: _symbolController.text.trim().toUpperCase(),
      direction: _direction,
      entry: entry,
      exit: exit,
      result: _result,
      profitLoss: profitLoss,
      notes: _notesController.text.trim(),
    );

    // Use the JournalBloc that was passed into this page.
    widget.journalBloc.add(
      JournalUpdateTrade(updatedTrade),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.journalBloc,

      child: BlocListener<JournalBloc, JournalState>(
        listener: (context, state) {
          // ================================================================
          // SUCCESS
          // ================================================================

          if (state is JournalLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Trade updated successfully.',
                ),
              ),
            );

            Navigator.pop(context);
          }

          // ================================================================
          // FAILURE
          // ================================================================

          if (state is JournalFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                ),
              ),
            );
          }
        },

        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Edit Trade',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ==========================================================
                  // SYMBOL
                  // ==========================================================

                  TextFormField(
                    controller: _symbolController,
                    textCapitalization:
                        TextCapitalization.characters,

                    decoration: const InputDecoration(
                      labelText: 'Symbol',
                      hintText: 'e.g. XAUUSD',
                      border: OutlineInputBorder(),
                    ),

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter a symbol';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // ==========================================================
                  // DIRECTION
                  // ==========================================================

                  DropdownButtonFormField<String>(
                    initialValue: _direction,

                    decoration: const InputDecoration(
                      labelText: 'Direction',
                      border: OutlineInputBorder(),
                    ),

                    items: const [
                      DropdownMenuItem(
                        value: 'BUY',
                        child: Text('BUY'),
                      ),
                      DropdownMenuItem(
                        value: 'SELL',
                        child: Text('SELL'),
                      ),
                    ],

                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _direction = value;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  // ==========================================================
                  // ENTRY
                  // ==========================================================

                  TextFormField(
                    controller: _entryController,

                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),

                    decoration: const InputDecoration(
                      labelText: 'Entry Price',
                      border: OutlineInputBorder(),
                    ),

                    validator: _validateNumber,
                  ),

                  const SizedBox(height: 20),

                  // ==========================================================
                  // EXIT
                  // ==========================================================

                  TextFormField(
                    controller: _exitController,

                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),

                    decoration: const InputDecoration(
                      labelText: 'Exit Price',
                      border: OutlineInputBorder(),
                    ),

                    validator: _validateNumber,
                  ),

                  const SizedBox(height: 20),

                  // ==========================================================
                  // RESULT
                  // ==========================================================

                  DropdownButtonFormField<String>(
                    initialValue: _result,

                    decoration: const InputDecoration(
                      labelText: 'Result',
                      border: OutlineInputBorder(),
                    ),

                    items: const [
                      DropdownMenuItem(
                        value: 'WIN',
                        child: Text('WIN'),
                      ),
                      DropdownMenuItem(
                        value: 'LOSS',
                        child: Text('LOSS'),
                      ),
                    ],

                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _result = value;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  // ==========================================================
                  // PROFIT / LOSS
                  // ==========================================================

                  TextFormField(
                    controller: _profitLossController,

                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),

                    decoration: const InputDecoration(
                      labelText: 'Profit / Loss',
                      border: OutlineInputBorder(),
                    ),

                    validator: _validateNumber,
                  ),

                  const SizedBox(height: 20),

                  // ==========================================================
                  // NOTES
                  // ==========================================================

                  TextFormField(
                    controller: _notesController,
                    maxLines: 4,

                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      hintText:
                          'Add notes about this trade...',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ==========================================================
                  // UPDATE BUTTON
                  // ==========================================================

                  BlocBuilder<JournalBloc, JournalState>(
                    builder: (context, state) {
                      final isLoading =
                          state is JournalLoading;

                      return SizedBox(
                        height: 52,

                        child: ElevatedButton(
                          onPressed:
                              isLoading ? null : _submit,

                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      CircularProgressIndicator(),
                                )
                              : const Text(
                                  'Update Trade',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // NUMBER VALIDATION
  // ==========================================================================

  String? _validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a value';
    }

    if (double.tryParse(value.trim()) == null) {
      return 'Please enter a valid number';
    }

    return null;
  }
}

