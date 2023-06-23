import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sutt_task_2/Logic/userprovider.dart';
import 'package:sutt_task_2/Models/model.dart';
import 'dart:async';
import 'package:sutt_task_2/Storage%20and%20API/firebase_storage.dart';
import 'package:sutt_task_2/Storage and API/secure_storage.dart';
import 'package:http/http.dart' as http;

Future<List<Movie>> fetchMoviesByTitle(String title) async {
  if(title==''){
    return Future(() => likedMovies);
  }
  final dio = Dio();
  final baseUrl = 'https://movies-tvshows-data-imdb.p.rapidapi.com/';
  final searchHeaders = {
    'X-RapidAPI-Key': '7482dff3eemshc3bfe79c2954757p15492bjsnf3fd48620e8d',
    'Type' : 'get-movies-by-title',
    'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com',
  };

  final searchResponse = await dio.get(baseUrl,
      queryParameters: {'title' : title},
    options: Options(headers: searchHeaders)
  );

  if (searchResponse.statusCode == 200) {
    final List searchData = searchResponse.data['movie_results'];
    final List<Movie> movies = [];

    // Fetch details for each movie
    await completedetails(movies, searchData);
    // print(movies);
    UserSecureStorage.setMovies(movies);
    return movies;
  } else {
    throw Exception('Failed to fetch movies');
  }
}

Future<void> completedetails(List<Movie> movies, List data) async {
  final dio = Dio();
  for(dynamic movie in data){
    final movieId = movie['imdb_id'];
    final detailsHeaders = {
      'X-RapidAPI-Key': '7482dff3eemshc3bfe79c2954757p15492bjsnf3fd48620e8d',
      'Type' : 'get-movie-details',
      'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com',
    };

    final detailsResponse = await dio.get(
        'https://movies-tvshows-data-imdb.p.rapidapi.com/',
        options: Options(headers: detailsHeaders),
        queryParameters: {'movieid' : movieId}
    );

    final imgresponse = await dio.get(
        'https://movies-tvshows-data-imdb.p.rapidapi.com/',
        queryParameters: {'movieid' : movieId},
        options: Options(
            headers: {
              'X-RapidAPI-Key': '7482dff3eemshc3bfe79c2954757p15492bjsnf3fd48620e8d',
              'Type' : 'get-movies-images-by-imdb',
              'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com',
            }
        )
    );

    if (detailsResponse.statusCode == 200 && imgresponse.statusCode ==200) {
      print('%%%%');

      // Create a Movie object with the fetched details
      final movie = Movie(
        description: detailsResponse.data['description'] ?? "Description not available",
        rating: detailsResponse.data['imdb_rating'] ?? '0',
        name: detailsResponse.data['title'] ,
        imagePath: imgresponse.data['poster'] == null|| imgresponse.data['poster']  == "" ? "https://images.unsplash.com/photo-1500462918059-b1a0cb512f1d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80" : imgresponse.data['poster'],
        videoPath: detailsResponse.data['youtube_trailer_key'] ?? '',
        category: detailsResponse.data['rated'] ?? "not available" ,
        year: (detailsResponse.data['year'] ?? 000).toString(),
        duration: Duration(minutes: (detailsResponse.data['runtime']) ?? 0) ,
        tagline: detailsResponse.data['tagline'] ?? 'no tagline available',
      );
      movies.add(movie);
    } else {
      throw Exception('Failed to fetch movie details');
    }
  }
}

void checkNetworkAvailability(WidgetRef ref) {
  Timer.periodic(const Duration(seconds: 2), (_) async {
    final onlineState = ref.read(onlinestateProvider);
    bool isNetworkAvailable = false;
    try {
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos/1'));
      isNetworkAvailable = true;
      if (isNetworkAvailable) {
        if (!onlineState) {
          // Network is available
          ref.watch(onlinestateProvider.notifier).update((state) => true);
          print('Network is available');
        }
      }
    } catch (e) {
      if (onlineState) {
        // Network is not available
        ref.watch(onlinestateProvider.notifier).update((state) => false);
        print('Network is not available');
      }
    }
  });
}