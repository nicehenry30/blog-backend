import '../../domain/entities/trading_signal.dart';
import 'signal_history_model.dart';

class TradingSignalModel extends TradingSignal {
  const TradingSignalModel({
    required super.id,
    required super.symbolId,
    required super.symbol,
    required super.symbolName,
    required super.assetType,
    required super.brokerSymbol,
    required super.digits,

    super.analysis,
    super.aiScore,
    super.aiComment,

    required super.direction,

    required super.entryPrice,
    required super.stopLoss,
    required super.takeProfit,

    super.takeProfit2,
    super.takeProfit3,

    required super.timeframe,

    required super.signalQuality,
    required super.overallConfidence,

    super.strategy,

    required super.confluences,

    super.chartImage,
    super.chartImageUrl,

    required super.createdAt,
    super.publishedAt,

    required super.status,

    required super.visibility,
    required super.locked,
    required super.canView,
    super.upgradePlan,

    required super.histories,
  });

  factory TradingSignalModel.fromJson(Map<String, dynamic> json) {
    final symbol = json['symbol'] as Map<String, dynamic>;

    final histories = (json['histories'] as List? ?? [])
        .map(
          (history) =>
              SignalHistoryModel.fromJson(history as Map<String, dynamic>),
        )
        .toList();

    return TradingSignalModel(
      id: json['id'],

      symbolId: symbol['id'],

      symbol: symbol['symbol'],

      symbolName: symbol['name'],

      assetType: symbol['asset_type'],

      brokerSymbol: symbol['broker_symbol'] ?? symbol['symbol'] ?? '',

      digits: symbol['digits'],

      analysis: json['analysis'],

      aiScore: json['ai_score'] != null
          ? (json['ai_score'] as num).toDouble()
          : null,

      aiComment: json['ai_comment'],

      direction: json['direction'] ?? '',

      entryPrice: (json['entry_price'] as num).toDouble(),

      stopLoss: (json['stop_loss'] as num).toDouble(),

      takeProfit: (json['take_profit'] as num).toDouble(),

      takeProfit2: json['take_profit_2'] != null
          ? (json['take_profit_2'] as num).toDouble()
          : null,

      takeProfit3: json['take_profit_3'] != null
          ? (json['take_profit_3'] as num).toDouble()
          : null,

      timeframe: json['timeframe'] ?? '',

      signalQuality: (json['signal_quality'] as num).toDouble(),

      overallConfidence: (json['overall_confidence'] as num).toDouble(),

      strategy: json['strategy'],

      confluences: List<String>.from(json['confluences'] ?? []),

      chartImage: json['chart_image'],

      chartImageUrl: json['chart_image_url'],

      createdAt: DateTime.parse(json['created_at']),

      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'])
          : null,

      status: json['status'] ?? '',

      visibility: json['visibility'] ?? 'free',

      locked: json['locked'] ?? false,

      canView: json['can_view'] ?? true,

      upgradePlan: json['upgrade_plan'],

      histories: histories,
    );
  }
}
