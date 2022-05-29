import 'package:aplikasi_berita/common/exception.dart';
import 'package:aplikasi_berita/data/datasources/db/database_helper.dart';
import 'package:aplikasi_berita/data/models/article_table.dart';

abstract class ArticleLocalDataSource {
  Future<String> insertBookmarkArticle(ArticleTable article);
  Future<String> removeBookmarkArticle(ArticleTable article);

  Future<ArticleTable?> getArticleByUrl(String url);
  Future<List<ArticleTable>> getBookmarkArticles();

  Future<void> cacheTopHeadlineArticles(List<ArticleTable> articles);
  Future<List<ArticleTable>> getCachedTopHeadlineArticles();

  Future<void> cacheHeadlineBussinessArticle(List<ArticleTable> articles);
  Future<List<ArticleTable>> getCachedHeadlineBussinessArticles();
}

class ArticleLocalDataSourceImpl implements ArticleLocalDataSource {
  final DatabaseHelper databaseHelper;

  ArticleLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertBookmarkArticle(ArticleTable article) async {
    try {
      await databaseHelper.insertBookmarkArticle(article);
      return 'Berhasil menambahkan pada Bookmark';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeBookmarkArticle(ArticleTable article) async {
    try {
      await databaseHelper.removeBookmarkArticle(article);
      return 'Berhasil menghapus pada Bookmark';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<ArticleTable?> getArticleByUrl(String url) async {
    final result = await databaseHelper.getArticleByUrl(url);
    if (result != null) {
      return ArticleTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<ArticleTable>> getBookmarkArticles() async {
    final result = await databaseHelper.getBookmarkArticles();
    return result.map((data) => ArticleTable.fromMap(data)).toList();
  }

  @override
  Future<void> cacheTopHeadlineArticles(List<ArticleTable> articles) async {
    await databaseHelper.clearCacheArticles('top headline');
    await databaseHelper.insertCacheTransactionArticles(
        articles, 'top headline');
  }

  @override
  Future<List<ArticleTable>> getCachedTopHeadlineArticles() async {
    final result = await databaseHelper.getCacheArticles('top headline');
    if (result.length > 0) {
      return result.map((data) => ArticleTable.fromMap(data)).toList();
    } else {
      throw CacheException("Gagal Mendapatkan Data: (");
    }
  }

  @override
  Future<void> cacheHeadlineBussinessArticle(
      List<ArticleTable> articles) async {
    await databaseHelper.clearCacheArticles('top headline');
    await databaseHelper.insertCacheTransactionArticles(
        articles, 'top bussiness');
  }

  @override
  Future<List<ArticleTable>> getCachedHeadlineBussinessArticles() async {
    final result = await databaseHelper.getCacheArticles('top bussiness');
    if (result.length > 0) {
      return result.map((data) => ArticleTable.fromMap(data)).toList();
    } else {
      throw CacheException("Gagal Mendapatkan Data: (");
    }
  }
}
