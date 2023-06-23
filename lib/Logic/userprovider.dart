import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:sutt_task_2/Storage and API/secure_storage.dart';
import 'package:sutt_task_2/Models/model.dart';
import 'package:sutt_task_2/Storage and API/api_services.dart';
import 'dart:async';


final searchqueryProvider = StateProvider<String>((ref) => "");
final likedMovieProvider = StateProvider<List<Movie>>((ref) => []);
final offlineMovieProvider = StateProvider<List<Movie>>((ref) => []);
final offlineMovieListProvider = StateProvider<Future<List<Movie>>>((ref) => UserSecureStorage.getMovies());
final loginstateProvider = StateProvider<bool>((ref) => false);
final fetchmovieProvider = FutureProvider.family((ref,String title) => fetchMoviesByTitle(title));

final onlinestateProvider = StateProvider<bool>((ref) => false);



void removeMovieFromLikedMovies(Movie movie, WidgetRef ref) {
  ref.watch(likedMovieProvider.notifier).state = ref
      .watch(likedMovieProvider.notifier)
      .state
      .where((m) => m != movie)
      .toList();
}

final userprovider = ChangeNotifierProvider<UserNotifier>((ref) {
  return UserNotifier();
});

class UserNotifier extends ChangeNotifier {
  String _username = '';
  String _loggedIn = 'false';

  String get username => _username;
  String get loggedIn => _loggedIn;

  Future<void> initialize() async {
    _username = await UserSecureStorage.getUsername() ?? '';
    final loggedInValue = await UserSecureStorage.getLoggedIn();
    _loggedIn = loggedInValue;
    notifyListeners();
  }

  void setUsername(String username) {
    _username = username;
    UserSecureStorage.setUsername(username);
    notifyListeners();
  }

  void setLoggedIn(String loggedIn) {
    _loggedIn = loggedIn;
    UserSecureStorage.setLoggedIn(loggedIn.toString());
    notifyListeners();
  }
}