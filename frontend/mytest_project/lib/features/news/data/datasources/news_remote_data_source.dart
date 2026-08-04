import '../models/news_model.dart';

abstract interface class NewsRemoteDataSource {
  Future<List<NewsModel>> getNews();

  Future<NewsModel> getNewsDetails(int newsId);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  @override
  Future<List<NewsModel>> getNews() async {
    throw UnimplementedError();
  }

  @override
  Future<NewsModel> getNewsDetails(int newsId) async {
    throw UnimplementedError();
  }
}
