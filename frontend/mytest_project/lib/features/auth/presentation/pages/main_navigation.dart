import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mytest_project/core/di/injection_container.dart';

import 'package:mytest_project/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mytest_project/features/signals/presentation/pages/signals_page.dart';
import 'package:mytest_project/features/market_alerts/presentation/pages/market_alerts_page.dart';
import 'package:mytest_project/features/journal/presentation/pages/journal_page.dart';
import 'package:mytest_project/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:mytest_project/features/ai_market_analysis/presentation/pages/ai_market_analysis_page.dart';
import 'package:mytest_project/features/more/presentation/pages/more_page.dart';

class MainNavigation extends StatefulWidget {
  final String name;
  final String email;

  const MainNavigation({super.key, required this.name, required this.email});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    DashboardPage(name: widget.name, email: widget.email),

    const SignalsPage(),

    const AiMarketAnalysisPage(),

    const MarketAlertsPage(),

    BlocProvider(
      create: (_) =>
          serviceLocator<JournalBloc>()..add(const JournalLoadTrades()),
      child: const JournalPage(),
    ),

    const MorePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onItemTapped,

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            selectedIcon: Icon(Icons.show_chart),
            label: 'Signals',
          ),

          NavigationDestination(
            icon: Icon(Icons.psychology_outlined),
            selectedIcon: Icon(Icons.psychology),
            label: 'AI',
          ),

          NavigationDestination(
            icon: Icon(Icons.warning_amber_outlined),
            selectedIcon: Icon(Icons.warning_amber),
            label: 'Alerts',
          ),

          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Journal',
          ),

          NavigationDestination(
            icon: Icon(Icons.more_horiz_outlined),
            selectedIcon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
