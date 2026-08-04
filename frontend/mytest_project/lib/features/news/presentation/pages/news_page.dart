import 'package:flutter/material.dart';

import '../widgets/news_filter_chips.dart';
import '../widgets/news_header.dart';
import '../widgets/news_search_bar.dart';

import '../widgets/news_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';

import '../bloc/news_bloc.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int selectedFilter = 0;
  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    serviceLocator<NewsBloc>().add(LoadNews());
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Market News",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(16), child: NewsHeader()),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: NewsSearchBar(onChanged: (value) {}),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: NewsFilterChips(
                selectedIndex: selectedFilter,
                onSelected: (index) {
                  setState(() {
                    selectedFilter = index;
                  });
                },
              ),
            ),

            const SizedBox(height: 16),

            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: "Today"),
                Tab(text: "Upcoming"),
                Tab(text: "History"),
              ],
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildNewsList(),
                  _buildNewsList(),
                  _buildNewsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsList() {
    return BlocBuilder<NewsBloc, NewsState>(
      bloc: serviceLocator<NewsBloc>(),
      builder: (context, state) {
        if (state is NewsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NewsFailure) {
          return Center(child: Text(state.message));
        }

        if (state is NewsLoaded) {
          if (state.news.isEmpty) {
            return const Center(child: Text('No news available.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 20),
            itemCount: state.news.length,
            itemBuilder: (context, index) {
              final news = state.news[index];

              return NewsCard(
                news: news,
                onTap: () {
                  // Open News Details
                },
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
