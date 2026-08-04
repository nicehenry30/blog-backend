class Trade {
final int? id;
final String symbol;
final String direction;
final double entry;
final double exit;
final String result;
final double profitLoss;
final String notes;

const Trade({
this.id,
required this.symbol,
required this.direction,
required this.entry,
required this.exit,
required this.result,
required this.profitLoss,
required this.notes,
});

bool get isWin => result == 'WIN';

bool get isLoss => result == 'LOSS';

// Convert Trade JSON from Laravel into a Trade object.
factory Trade.fromJson(Map<String, dynamic> json) {
return Trade(
id: json['id'] as int?,
symbol: json['symbol'] as String,
direction: json['direction'] as String,
entry: (json['entry'] as num).toDouble(),
exit: (json['exit'] as num).toDouble(),
result: json['result'] as String,
profitLoss: (json['profit_loss'] as num).toDouble(),
notes: json['notes'] as String? ?? '',
);
}

// Convert Trade object into JSON for Laravel.
Map<String, dynamic> toJson() {
return {
'symbol': symbol,
'direction': direction,
'entry': entry,
'exit': exit,
'result': result,
'profit_loss': profitLoss,
'notes': notes,
};
}
}
