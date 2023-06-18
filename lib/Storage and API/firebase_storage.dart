import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sutt_task_2/Models/model.dart';

final firebaseAuth = FirebaseAuth.instance;
final firebaseFirestore = FirebaseFirestore.instance;

void addToLikedMovies(Movie movie) async {
  try {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      final userId = user.uid;
      final likedMoviesCollection = firebaseFirestore.collection('users').doc(userId).collection('likedmovies');
      await likedMoviesCollection.add({
        'rating': movie.rating,
        'description' : movie.description,
        'name': movie.name,
        'imagePath': movie.imagePath,
        'videoPath': movie.videoPath,
        'category': movie.category,
        'year': movie.year,
        'duration': movie.duration.inSeconds,
        'tagline': movie.tagline,
      });

      print('Movie added to liked movies successfully!');
    }
  } catch (e) {
    print('Failed to add movie to liked movies: $e');
  }
}

void deleteFromLikedMovies(String movieId) async {
  try {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      final userId = user.uid;
      final likedMoviesCollection = firebaseFirestore.collection('users').doc(userId).collection('likedmovies');

      final movieDoc = await likedMoviesCollection.doc(movieId).get();
      if (movieDoc.exists) {
        await movieDoc.reference.delete();
        print('Movie deleted from liked movies successfully!');
      } else {
        print('Movie not found in liked movies.');
      }
    }
  } catch (e) {
    print('Failed to delete movie from liked movies: $e');
  }
}
