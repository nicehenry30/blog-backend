import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/crypto_payment.dart';
import '../bloc/subscription_bloc.dart';

class CryptoPaymentPage extends StatefulWidget {
  final CryptoPayment payment;

  const CryptoPaymentPage({
    super.key,
    required this.payment,
  });

  @override
  State<CryptoPaymentPage> createState() =>
      _CryptoPaymentPageState();
}

class _CryptoPaymentPageState
    extends State<CryptoPaymentPage> {
  late final TextEditingController
      _transactionHashController;

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _transactionHashController =
        TextEditingController();
  }

  @override
  void dispose() {
    _transactionHashController.dispose();
    super.dispose();
  }

  void _copyWalletAddress() {
    Clipboard.setData(
      ClipboardData(
        text: widget.payment.walletAddress,
      ),
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Wallet address copied.',
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
  }

  void _submitTransaction() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    context.read<SubscriptionBloc>().add(
          SubmitSubscriptionCryptoTransaction(
            paymentId:
                widget.payment.paymentId,
            transactionHash:
                _transactionHashController
                    .text
                    .trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
        SubscriptionBloc,
        SubscriptionState>(
      listener: (context, state) {
        if (state
            is SubscriptionCryptoPaymentSubmitted) {
          if (!mounted) {
            return;
          }

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                ),
                behavior:
                    SnackBarBehavior.floating,
              ),
            );

          Navigator.pop(context);
        }

        if (state is SubscriptionFailure) {
          if (!mounted) {
            return;
          }

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                ),
                behavior:
                    SnackBarBehavior.floating,
              ),
            );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Pay with USDT',
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding:
                  const EdgeInsets.all(16),
              children: [
                _buildHeader(),

                const SizedBox(height: 20),

                _buildPaymentSummary(),

                const SizedBox(height: 20),

                _buildWalletSection(),

                const SizedBox(height: 20),

                _buildInstructions(),

                const SizedBox(height: 20),

                _buildTransactionForm(),

                const SizedBox(height: 24),

                BlocBuilder<
                    SubscriptionBloc,
                    SubscriptionState>(
                  builder: (context, state) {
                    final isSubmitting =
                        state
                            is SubscriptionCryptoSubmitting;

                    return SizedBox(
                      width: double.infinity,
                      height: 54,
                      child:
                          ElevatedButton.icon(
                        onPressed:
                            isSubmitting
                                ? null
                                : _submitTransaction,
                        icon: isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color:
                                      Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons
                                    .send_rounded,
                              ),
                        label: Text(
                          isSubmitting
                              ? 'Submitting...'
                              : 'Submit Transaction',
                        ),
                        style:
                            ElevatedButton
                                .styleFrom(
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              14,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                _buildWarning(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(20),
        color:
            Colors.blue.withValues(
          alpha: 0.08,
        ),
        border: Border.all(
          color:
              Colors.blue.withValues(
            alpha: 0.20,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue
                  .withValues(alpha: 0.12),
            ),
            child: const Icon(
              Icons.currency_bitcoin,
              size: 34,
              color: Colors.blue,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'USDT Payment',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Send USDT using the TRC20 network.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return _SectionCard(
      title: 'Payment Details',
      icon: Icons.receipt_long,
      child: Column(
        children: [
          _InfoRow(
            label: 'Amount',
            value:
                '${_formatAmount(widget.payment.amountUsdt)} USDT',
            valueBold: true,
          ),

          const Divider(
            height: 24,
          ),

          _InfoRow(
            label: 'Payment Method',
            value:
                widget.payment.paymentMethod,
          ),

          const SizedBox(height: 12),

          _InfoRow(
            label: 'Network',
            value:
                widget.payment.network,
          ),

          const SizedBox(height: 12),

          _InfoRow(
            label: 'Reference',
            value:
                widget.payment.reference,
          ),
        ],
      ),
    );
  }

  Widget _buildWalletSection() {
    return _SectionCard(
      title: 'Receiving Wallet',
      icon: Icons.account_balance_wallet,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Send the exact amount of USDT to this wallet:',
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color:
                  Colors.grey.shade100,
              borderRadius:
                  BorderRadius.circular(12),
              border: Border.all(
                color:
                    Colors.grey.shade300,
              ),
            ),
            child: SelectableText(
              widget.payment.walletAddress,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed:
                  _copyWalletAddress,
              icon: const Icon(
                Icons.copy_rounded,
              ),
              label: const Text(
                'Copy Wallet Address',
              ),
              style:
                  OutlinedButton.styleFrom(
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return _SectionCard(
      title: 'How to Pay',
      icon: Icons.info_outline,
      child: Column(
        children: [
          _InstructionStep(
            number: '1',
            text:
                'Open your crypto wallet and choose USDT.',
          ),
          _InstructionStep(
            number: '2',
            text:
                'Select the TRC20 (TRON) network.',
          ),
          _InstructionStep(
            number: '3',
            text:
                'Send exactly ${_formatAmount(widget.payment.amountUsdt)} USDT to the receiving wallet above.',
          ),
          _InstructionStep(
            number: '4',
            text:
                'Wait for the transaction to be broadcast.',
          ),
          _InstructionStep(
            number: '5',
            text:
                'Copy the blockchain transaction hash and submit it below.',
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionForm() {
    return _SectionCard(
      title: 'Transaction Hash',
      icon: Icons.link,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'After sending the payment, enter the transaction hash here.',
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 14),

          TextFormField(
            controller:
                _transactionHashController,
            maxLines: 4,
            minLines: 2,
            textInputAction:
                TextInputAction.newline,
            decoration:
                InputDecoration(
              hintText:
                  'Paste your TRON transaction hash',
              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),
              enabledBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
                borderSide:
                    BorderSide(
                  color:
                      Colors.grey.shade300,
                ),
              ),
            ),
            validator: (value) {
              final hash =
                  value?.trim() ?? '';

              if (hash.isEmpty) {
                return 'Please enter your transaction hash.';
              }

              if (hash.length > 255) {
                return
                    'Transaction hash is too long.';
              }

              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWarning() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange
            .withValues(alpha: 0.08),
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: Colors.orange
              .withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              'Only send USDT through the TRC20 network. '
              'Sending another asset or using another network '
              'may result in permanent loss of funds.',
              style: TextStyle(
                color:
                    Colors.grey.shade800,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    return amount
        .toStringAsFixed(2);
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 21,
                ),

                const SizedBox(width: 9),

                Text(
                  title,
                  style:
                      const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            child,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool valueBold;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 14,
              fontWeight: valueBold
                  ? FontWeight.bold
                  : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _InstructionStep
    extends StatelessWidget {
  final String number;
  final String text;

  const _InstructionStep({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue
                  .withValues(alpha: 0.10),
            ),
            child: Text(
              number,
              style: const TextStyle(
                fontWeight:
                    FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(
                top: 4,
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}