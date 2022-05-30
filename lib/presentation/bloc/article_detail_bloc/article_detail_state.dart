part of 'article_detail_bloc.dart';

class ArticleDetailState extends Equatable {
  final String bookmarkMessage;
  final bool isAddedtoBookmark;

  ArticleDetailState({
    required this.bookmarkMessage,
    required this.isAddedtoBookmark,
  });

  ArticleDetailState copyWith({
    String? bookmarkMessage,
    bool? isAddedtoBookmark,
  }) {
    return ArticleDetailState(
      bookmarkMessage: bookmarkMessage ?? this.bookmarkMessage,
      isAddedtoBookmark: isAddedtoBookmark ?? this.isAddedtoBookmark,
    );
  }

  factory ArticleDetailState.initial() {
    return ArticleDetailState(
      bookmarkMessage: '',
      isAddedtoBookmark: false,
    );
  }

  @override
  List<Object> get props => [bookmarkMessage, isAddedtoBookmark];
}
