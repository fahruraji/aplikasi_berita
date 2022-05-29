import 'package:dartz/dartz.dart';
import 'package:aplikasi_berita/common/failure.dart';
import 'package:aplikasi_berita/domain/entities/article.dart';
import 'package:aplikasi_berita/domain/repositories/article_repository.dart';

class SaveBookmarkArticle {
  final ArticleRepository repository;

  SaveBookmarkArticle(this.repository);

  Future<Either<Failure, String>> execute(Article article) {
    return repository.saveBookmarkArticle(article);
  }
}
