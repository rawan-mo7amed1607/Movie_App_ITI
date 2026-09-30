import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/movies_cubit.dart';
import '../logic/movies_state.dart';
import '../data/favorites_service.dart';
import '../data/movie_model.dart';
import 'movie_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesService favoritesService = FavoritesService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies App '),
      ),
      body: BlocBuilder<MoviesCubit, MoviesState>(
        builder: (context, state) {
          if (state is MoviesLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFC107)),
            );
          } else if (state is MoviesErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 10),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC107),
                    ),
                    onPressed: () {
                      context.read<MoviesCubit>().fetchPopularMovies();
                    },
                    child: const Text('Try Again', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            );
          } else if (state is MoviesSuccessState) {
            final top10Movies = state.movies.take(10).toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Top 10 Movies',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFC107),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: top10Movies.length,
                      itemBuilder: (context, index) {
                        final movie = top10Movies[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MovieDetailsScreen(movie: movie),
                              ),
                            );
                          },
                          child: Container(
                            width: 140,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: (movie.posterPath != null && movie.posterPath!.isNotEmpty)
                                      ? Image.network(
                                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                          height: 200,
                                          width: 140,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          height: 200,
                                          color: Colors.grey[800],
                                          child: const Icon(Icons.movie, color: Colors.grey),
                                        ),
                                ),
                                
                                Positioned(
                                  bottom: -10,
                                  left: 0,
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      fontSize: 65,
                                      fontWeight: FontWeight.w900,
                                      color: const Color(0xFFFFC107).withOpacity(0.9),
                                      shadows: const [
                                        Shadow(blurRadius: 10, color: Colors.black),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text(
                      'Popular Movies',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
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
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1F1F1F),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: (movie.posterPath != null && movie.posterPath!.isNotEmpty)
                                          ? Image.network(
                                              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(color: Colors.grey[800]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            movie.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.star, color: Colors.amber, size: 16),
                                              const SizedBox(width: 4),
                                              Text(
                                                movie.voteAverage.toStringAsFixed(1),
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: StreamBuilder<List<MovieModel>>(
                                    stream: favoritesService.getFavorites(),
                                    builder: (context, snapshot) {
                                      final favorites = snapshot.data ?? [];
                                      final isFav = favorites.any((element) => element.id == movie.id);

                                      return CircleAvatar(
                                        backgroundColor: Colors.black54,
                                        radius: 18,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: Icon(
                                            isFav ? Icons.favorite : Icons.favorite_border,
                                            color: Colors.redAccent,
                                            size: 20,
                                          ),
                                          onPressed: () async {
                                            if (isFav) {
                                              await favoritesService.removeFromFavorites(movie.id);
                                            } else {
                                              await favoritesService.addToFavorites(movie);
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}