import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/ai_market_analysis_bloc.dart';
import '../bloc/ai_market_analysis_event.dart';
import '../bloc/ai_market_analysis_state.dart';

class AiMarketAnalysisPage extends StatefulWidget {
  const AiMarketAnalysisPage({super.key});

  @override
  State<AiMarketAnalysisPage> createState() => _AiMarketAnalysisPageState();
}

class _AiMarketAnalysisPageState extends State<AiMarketAnalysisPage> {
  final _symbolController = TextEditingController(text: 'XAU/USD');

  final _balanceController = TextEditingController(text: '10000');

  final _riskController = TextEditingController(text: '1');

  @override
  void dispose() {
    _symbolController.dispose();
    _balanceController.dispose();
    _riskController.dispose();
    super.dispose();
  }

  void _analyzeMarket() {
    final symbol = _symbolController.text.trim();
    final accountBalance = double.tryParse(_balanceController.text.trim());
    final riskPercent = double.tryParse(_riskController.text.trim());

    if (symbol.isEmpty || accountBalance == null || riskPercent == null) {
      return;
    }

    context.read<AiMarketAnalysisBloc>().add(
      AnalyzeMarketRequested(
        symbol: symbol,
        accountBalance: accountBalance,
        riskPercent: riskPercent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Market Analysis')),
      body: BlocBuilder<AiMarketAnalysisBloc, AiMarketAnalysisState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _symbolController,
                  decoration: const InputDecoration(
                    labelText: 'Symbol',
                    hintText: 'XAU/USD',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _balanceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Account Balance',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _riskController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Risk %',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                FilledButton(
                  onPressed: state is AiMarketAnalysisLoading
                      ? null
                      : _analyzeMarket,
                  child: state is AiMarketAnalysisLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Analyze Market'),
                ),

                const SizedBox(height: 24),

                if (state is AiMarketAnalysisFailure)
                  _buildErrorCard(state.message),

                if (state is AiMarketAnalysisSuccess)
                  _buildAnalysisResult(state.analysis),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analysis Failed',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(message),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisResult(dynamic analysis) {
    final opportunity = analysis.opportunityAssessment;

    final interpretation = analysis.aiInterpretation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Market Assessment',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                _buildInfoRow('Status', analysis.status),

                _buildInfoRow('Direction', opportunity.direction),

                _buildInfoRow('Opportunity', opportunity.opportunity),

                _buildInfoRow('Agreement', opportunity.agreement),

                _buildInfoRow(
                  'Proceed to Entry',
                  opportunity.proceedToEntry ? 'Yes' : 'No',
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Interpretation',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Text(
                  interpretation.summary,
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Reasoning',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                ...interpretation.reasoning.map((item) => _buildBullet(item)),

                const SizedBox(height: 20),

                const Text(
                  'Key Evidence',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                ...interpretation.keyEvidence.map((item) => _buildBullet(item)),

                const SizedBox(height: 20),

                _buildInfoRow('Next Step', interpretation.nextStep),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        if (opportunity.supportingSources.isNotEmpty)
          _buildListCard(
            title: 'Supporting Evidence Sources',
            items: opportunity.supportingSources,
          ),

        if (opportunity.limitations.isNotEmpty)
          _buildListCard(title: 'Limitations', items: opportunity.limitations),

        if (interpretation.uncertainty.isNotEmpty)
          _buildListCard(
            title: 'Uncertainty',
            items: interpretation.uncertainty,
          ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildListCard({required String title, required List<String> items}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...items.map((item) => _buildBullet(item)),
          ],
        ),
      ),
    );
  }
}
