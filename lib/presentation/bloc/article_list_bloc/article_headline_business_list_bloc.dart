part of 'article_list_bloc.dart';

class ArticleHeadlineBusinessListBloc
    extends Bloc<ArticleListEVent, ArticleListState> {
  final GetHeadlineBusinessArticles getHeadlineBusinessArticles;
  ArticleHeadlineBusinessListBloc(this.getHeadlineBusinessArticles)
      : super(ArticleListEmpty()) {
    on<ArticleListEVent>((event, emit) async {
      emit(ArticleListLoading());
      final result = await getHeadlineBusinessArticles.execute();
      result.fold((failure) => emit(ArticleListError(failure.message)),
          (articlesData) {
        emit(ArticleListLoaded(articlesData));
        if (articlesData.isEmpty) {
          emit(ArticleListEmpty());
        }
      });
    });
  }
}
