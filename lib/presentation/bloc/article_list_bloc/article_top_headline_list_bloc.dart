part of 'article_list_bloc.dart';

class ArticleTopHeadlineListBloc
    extends Bloc<ArticleListEVent, ArticleListState> {
  final GetTopHeadlineArticles getTopHeadlineArticles;
  ArticleTopHeadlineListBloc(this.getTopHeadlineArticles)
      : super(ArticleListEmpty()) {
    on<ArticleListEVent>((event, emit) async {
      emit(ArticleListLoading());
      final result = await getTopHeadlineArticles.execute();
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
