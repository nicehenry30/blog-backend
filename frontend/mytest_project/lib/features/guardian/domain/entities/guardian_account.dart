class GuardianAccount {
  final int? id;
  final String platform;
  final String? accountNumber;
  final String? broker;
  final bool isConnected;
  final bool isEnabled;

  final double balance;
  final double equity;
  final double currentDrawdown;
  final int openPositions;
  final double dailyProfitLoss;

  const GuardianAccount({
    this.id,
    required this.platform,
    this.accountNumber,
    this.broker,
    required this.isConnected,
    required this.isEnabled,
    required this.balance,
    required this.equity,
    required this.currentDrawdown,
    required this.openPositions,
    required this.dailyProfitLoss,
  });

  const GuardianAccount.empty()
      : id = null,
        platform = 'MT4',
        accountNumber = null,
        broker = null,
        isConnected = false,
        isEnabled = false,
        balance = 0.0,
        equity = 0.0,
        currentDrawdown = 0.0,
        openPositions = 0,
        dailyProfitLoss = 0.0;

  GuardianAccount copyWith({
    int? id,
    String? platform,
    String? accountNumber,
    String? broker,
    bool? isConnected,
    bool? isEnabled,
    double? balance,
    double? equity,
    double? currentDrawdown,
    int? openPositions,
    double? dailyProfitLoss,
  }) {
    return GuardianAccount(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      accountNumber: accountNumber ?? this.accountNumber,
      broker: broker ?? this.broker,
      isConnected: isConnected ?? this.isConnected,
      isEnabled: isEnabled ?? this.isEnabled,
      balance: balance ?? this.balance,
      equity: equity ?? this.equity,
      currentDrawdown:
          currentDrawdown ?? this.currentDrawdown,
      openPositions:
          openPositions ?? this.openPositions,
      dailyProfitLoss:
          dailyProfitLoss ?? this.dailyProfitLoss,
    );
  }
}