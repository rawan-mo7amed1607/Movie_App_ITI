import 'package:flutter/material.dart';
import '../data/movie_model.dart';
import '../data/favorites_service.dart';

class MovieDetailsScreen extends StatelessWidget {
  final MovieModel movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final FavoritesService favoritesService = FavoritesService();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                movie.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                ),
              ),
              background: (movie.posterPath != null && movie.posterPath!.isNotEmpty)
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      fit: BoxFit.cover,
                    )
                  : Container(color: Colors.grey[800]),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 24),
                          const SizedBox(width: 6),
                          Text(
                            '${movie.voteAverage.toStringAsFixed(1)} / 10',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      StreamBuilder<List<MovieModel>>(
                        stream: favoritesService.getFavorites(),
                        builder: (context, snapshot) {
                          final favorites = snapshot.data ?? [];
                          final isFav = favorites.any((element) => element.id == movie.id);

                          return ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isFav ? Colors.redAccent : const Color(0xFFFFC107),
                            ),
                            onPressed: () async {
                              if (isFav) {
                                await favoritesService.removeFromFavorites(movie.id);
                              } else {
                                await favoritesService.addToFavorites(movie);
                              }
                            },
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.white : Colors.black,
                            ),
                            label: Text(
                              isFav ? 'Remove Favorite' : 'Add to Favorite',
                              style: TextStyle(
                                color: isFav ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFC107),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    movie.overview.isNotEmpty ? movie.overview : 'No description available.',
                    style: const TextStyle(fontSize: 16, color: Colors.white70, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}