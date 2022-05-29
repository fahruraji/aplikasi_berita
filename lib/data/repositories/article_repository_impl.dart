import 'dart:io';

import 'package:aplikasi_berita/common/exception.dart';
import 'package:aplikasi_berita/common/failure.dart';
import 'package:aplikasi_berita/common/network_info.dart';
import 'package:aplikasi_berita/data/datasources/article_local_data_source.dart';
import 'package:aplikasi_berita/data/datasources/article_remote_data_source.dart';
import 'package:aplikasi_berita/data/models/article_table.dart';
import 'package:aplikasi_berita/domain/entities/article.dart';
import 'package:aplikasi_berita/domain/entities/articles.dart';
import 'package:dartz/dartz.dart';
import 'package:aplikasi_berita/domain/repositories/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDataSource remoteDataSource;
  final ArticleLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ArticleRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, List<Article>>> getTopHeadlineArticles() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getTopHeadlineArticles();
        localDataSource.cacheTopHeadlineArticles(
            result.map((article) => ArticleTable.fromDTO(article)).toList());
        return Right(result.map((model) => model.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure(''));
      } on TlsException catch (e) {
        return Left(CommonFailure('Sertifikat tidak valid: \n${e.message}'));
      }
    } else {
      try {
        final result = await localDataSource.getCachedTopHeadlineArticles();
        return Right(result.map((model) => model.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getHeadlineBusinessArticles() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getTopHeadlineBussinessArticles();
        localDataSource.cacheTopHeadlineArticles(
            result.map((article) => ArticleTable.fromDTO(article)).toList());
        return Right(result.map((model) => model.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure(''));
      } on TlsException catch (e) {
        return Left(CommonFailure('Sertifikat tidak valid: \n${e.message}'));
      }
    } else {
      try {
        final result =
            await localDataSource.getCachedHeadlineBussinessArticles();
        return Right(result.map((model) => model.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getArticleCategory(
      String category) async {
    try {
      final result = await remoteDataSource.getArticleCategory(category);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(CommonFailure('Tidak dapat terkoneksi ke internet'));
    } on TlsException catch (e) {
      return Left(CommonFailure('Sertifikat tidak valid: \n${e.message}'));
    }
  }

  @override
  Future<Either<Failure, Articles>> searchArticle(String query,
      {int page = 1}) async {
    try {
      final result = await remoteDataSource.searchArticle(query, page);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(CommonFailure('Tidak dapat terkoneksi ke internet'));
    } on TlsException catch (e) {
      return Left(CommonFailure('Sertifikat tidak valid: \n${e.message}'));
    }
  }

  @override
  Future<Either<Failure, String>> saveBookmarkArticle(Article article) async {
    try {
      final result = await localDataSource
          .insertBookmarkArticle(ArticleTable.fromEntity(article));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Either<Failure, String>> removeBookmarkArticle(Article article) async {
    try {
      final result = await localDataSource
          .removeBookmarkArticle(ArticleTable.fromEntity(article));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> isAddedtoBookmark(String url) async {
    final result = await localDataSource.getArticleByUrl(url);
    return result != null;
  }

  @override
  Future<Either<Failure, List<Article>>> getBookmarkArticles() async {
    final result = await localDataSource.getBookmarkArticles();
    return Right(result.map((e) => e.toEntity()).toList());
  }
}
