import 'package:aplikasi_berita/domain/entities/article.dart';
import 'package:equatable/equatable.dart';

class Articles extends Equatable {
  Articles({
    required this.totalResults,
    required this.articles,
  });

  int totalResults;
  List<Article> articles;

  @override
  List<Object?> get props => [
        totalResults,
        articles,
      ];
}
