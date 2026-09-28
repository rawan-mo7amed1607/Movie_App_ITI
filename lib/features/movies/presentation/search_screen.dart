import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/movies_cubit.dart';
import '../logic/movies_state.dart';
import '../data/favorites_service.dart';
import '../data/movie_model.dart';
import 'movie_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FavoritesService _favoritesService = FavoritesService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies 🔍'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type movie title...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFFFC107)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          context.read<MoviesCubit>().fetchPopularMovies();
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFF1F1F1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) {
                setState(() {});
                if (query.trim().isNotEmpty) {
                  context.read<MoviesCubit>().searchMovies(query);
                } else {
                  context.read<MoviesCubit>().fetchPopularMovies();
                }
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<MoviesCubit, MoviesState>(
              builder: (context, state) {
                if (state is MoviesLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFFC107)),
                  );
                } else if (state is MoviesErrorState) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  );
                } else if (state is MoviesSuccessState) {
                  if (state.movies.isEmpty) {
                    return const Center(
                      child: Text(
                        'No movies found!',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.movies.length,
                    itemBuilder: (context, index) {
                      final movie = state.movies[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MovieDetailsScreen(movie: movie),
                            ),
                          );
                        },
                        child: Card(
                          color: const Color(0xFF1F1F1F),
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: (movie.posterPath != null && movie.posterPath!.isNotEmpty)
                                  ? Image.network(
                                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                      width: 60,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 60,
                                      height: 90,
                                      color: Colors.grey[800],
                                      child: const Icon(Icons.movie, color: Colors.grey),
                                    ),
                            ),
                            title: Text(
                              movie.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  movie.voteAverage.toStringAsFixed(1),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            // زر القلب التفاعلي التلقائي في البحث ❤️
                            trailing: StreamBuilder<List<MovieModel>>(
                              stream: _favoritesService.getFavorites(),
                              builder: (context, snapshot) {
                                final favorites = snapshot.data ?? [];
                                final isFav = favorites.any((element) => element.id == movie.id);

                                return IconButton(
                                  icon: Icon(
                                    isFav ? Icons.favorite : Icons.favorite_border,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () async {
                                    if (isFav) {
                                      await _favoritesService.removeFromFavorites(movie.id);
                                    } else {
                                      await _favoritesService.addToFavorites(movie);
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}