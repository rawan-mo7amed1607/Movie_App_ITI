import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/movie_api_service.dart';
import 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  final MovieApiService apiService;

  MoviesCubit(this.apiService) : super(MoviesInitialState());

  void fetchPopularMovies() async {
    emit(MoviesLoadingState());
    try {
      final movies = await apiService.getPopularMovies();
      emit(MoviesSuccessState(movies));
    } catch (e) {
      emit(MoviesErrorState(e.toString()));
    }
  }

  void searchMovies(String query) async {
    if (query.isEmpty) {
      fetchPopularMovies();
      return;
    }
    emit(MoviesLoadingState());
    try {
      final movies = await apiService.searchMovies(query);
      emit(MoviesSuccessState(movies));
    } catch (e) {
      emit(MoviesErrorState(e.toString()));
    }
  }
}