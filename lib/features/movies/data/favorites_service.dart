import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'movie_model.dart';

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  Future<void> addToFavorites(MovieModel movie) async {
    if (_userId.isEmpty) return;
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('favorites')
        .doc(movie.id.toString())
        .set({
      'id': movie.id,
      'title': movie.title,
      'overview': movie.overview,
      'poster_path': movie.posterPath,
      'vote_average': movie.voteAverage,
    });
  }

  Future<void> removeFromFavorites(int movieId) async {
    if (_userId.isEmpty) return;
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('favorites')
        .doc(movieId.toString())
        .delete();
  }

  Stream<List<MovieModel>> getFavorites() {
    if (_userId.isEmpty) return Stream.value([]);
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('favorites')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => MovieModel.fromJson(doc.data())).toList());
  }
}