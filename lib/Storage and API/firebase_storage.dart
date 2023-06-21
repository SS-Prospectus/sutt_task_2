import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sutt_task_2/Logic/userprovider.dart';
import 'package:sutt_task_2/Models/model.dart';

final firebaseAuth = FirebaseAuth.instance;
final firebaseFirestore = FirebaseFirestore.instance;

void addToLikedMovies(Movie movie, WidgetRef ref) async {
  try {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      final userId = user.uid;
      final likedMoviesCollection = firebaseFirestore.collection('users').doc(userId).collection('likedmovies');
      final addedDocRef = await likedMoviesCollection.add({
        'rating': movie.rating,
        'description' : movie.description,
        'name': movie.name,
        'imagePath': movie.imagePath,
        'videoPath': movie.videoPath,
        'category': movie.category,
        'year': movie.year,
        'duration': movie.duration.inMinutes,
        'tagline': movie.tagline,
        'movieid' : '',
      });
      var id = addedDocRef.id;
      await addedDocRef.update({'movieid' : id});
      final updatedMovie = Movie(
        description: movie.description,
        rating: movie.rating,
        name: movie.name,
        imagePath: movie.imagePath,
        videoPath: movie.videoPath,
        category: movie.category,
        year: movie.year,
        duration: movie.duration,
        tagline: movie.tagline,
        movieid: id,
      );
      ref.watch(likedMovieProvider.notifier).state.add(updatedMovie);
      print('Movie added to liked movies successfully!');
    }
  } catch (e) {
    print('Failed to add movie to liked movies: $e');
  }
}

void deleteFromLikedMovies(Movie movie,String movieId, WidgetRef ref) async {
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
    final container = ProviderContainer();
    final likedMovies = container.read(likedMovieProvider.notifier).state;
    container.read(likedMovieProvider.notifier).state = likedMovies.where((m) => m != movie).toList(); // Refresh the provider to reflect the modified state
    container.dispose();
  } catch (e) {
    print('Failed to delete movie from liked movies: $e');
  }
}


List<Movie> likedMovies = []; // Local list to store liked movies

void getLikedMovies() async {
  try {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      final userId = user.uid;
      final likedMoviesCollection = firebaseFirestore.collection('users').doc(userId).collection('likedmovies');

      final querySnapshot = await likedMoviesCollection.get();
      querySnapshot.docs.forEach((movieDoc) {
        final data = movieDoc.data();
        final movie = Movie(
          rating: data['rating'],
          description: data['description'],
          name: data['name'],
          imagePath: data['imagePath'],
          videoPath: data['videoPath'],
          category: data['category'],
          year: data['year'],
          duration: Duration(minutes: data['duration']),
          tagline: data['tagline'],
          movieid: data['movieid'],
        );
        likedMovies.add(movie);
      });
      print('Liked movies retrieved successfully!');
    }
  } catch (e) {
    print('Failed to retrieve liked movies: $e');
  }
}