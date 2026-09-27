import '../data/movie_model.dart';

abstract class MoviesState {}

class MoviesInitialState extends MoviesState {}

class MoviesLoadingState extends MoviesState {}

class MoviesSuccessState extends MoviesState {
  final List<MovieModel> movies;
  MoviesSuccessState(this.movies);
}

class MoviesErrorState extends MoviesState {
  final String message;
  MoviesErrorState(this.message);
}