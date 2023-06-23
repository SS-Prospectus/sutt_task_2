import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:sutt_task_2/Models/model.dart';

class UserSecureStorage {
  static final _storage = FlutterSecureStorage();
  static const _keyUsername = 'username';
  static const _keyLoggedIn = 'loggedin';

  static Future setUsername(String username) async =>
  await _storage.write(key: _keyUsername, value: username);

  static Future getUsername() async =>
  await _storage.read(key: _keyUsername);

  static Future setLoggedIn(String loggedin) async =>
      await _storage.write(key: _keyLoggedIn, value: loggedin);

  static Future getLoggedIn() async =>
      await _storage.read(key: _keyLoggedIn);

  static Future<void> setMovies(List<Movie> movies) async {
    final encodedMovies = movies.map((movie) => jsonEncode(movie.toJson())).toList();
    final encodedMoviesString = jsonEncode(encodedMovies);
    await _storage.write(key: 'movies', value: encodedMoviesString);
    print('Movies stored');
  }

  static Future<List<Movie>> getMovies() async {
    final encodedMoviesString = await _storage.read(key: 'movies');
    if (encodedMoviesString != null) {
      final encodedMovies = jsonDecode(encodedMoviesString) as List<dynamic>;
      final movies = encodedMovies
          .map((encodedMovie) => Movie.fromJson(jsonDecode(encodedMovie as String)))
          .toList();
      print('Movies loaded');
      return movies;
    } else {
      print('Empty Movies List loaded');
      return [];
    }
  }
}