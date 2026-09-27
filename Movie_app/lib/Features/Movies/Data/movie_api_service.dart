import 'package:dio/dio.dart';
import 'movie_model.dart';

class MovieApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _apiKey = 'c546d509397e9d74e11791c502eb896a';

  Future<List<MovieModel>> getPopularMovies() async {
    try {
      final response = await _dio.get('$_baseUrl/movie/popular?api_key=$_apiKey');
      final List results = response.data['results'];
      return results.map((e) => MovieModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch movies: $e');
    }
  }

  Future<List<MovieModel>> searchMovies(String query) async {
    try {
      final response = await _dio.get('$_baseUrl/search/movie?api_key=$_apiKey&query=$query');
      final List results = response.data['results'];
      return results.map((e) => MovieModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }
}