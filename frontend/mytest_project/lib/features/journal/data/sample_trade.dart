
import 'package:mytest_project/features/journal/domain/entities/trade.dart';

const List<Trade> sampleTrades = [
  Trade(
    id: 1,
    symbol: 'XAUUSD',
    direction: 'BUY',
    entry: 3350.00,
    exit: 3380.00,
    result: 'WIN',
    profitLoss: 30.00,
    notes: 'Good setup. Followed the trading plan and managed risk correctly.',
  ),
  Trade(
    id: 2,
    symbol: 'EURUSD',
    direction: 'SELL',
    entry: 1.0850,
    exit: 1.0870,
    result: 'LOSS',
    profitLoss: -20.00,
    notes: 'Entered too early. The market reversed before continuing lower.',
  ),
  Trade(
    id: 3,
    symbol: 'GBPUSD',
    direction: 'BUY',
    entry: 1.2700,
    exit: 1.2760,
    result: 'WIN',
    profitLoss: 60.00,
    notes: 'Strong bullish setup with good confirmation.',
  ),
];

