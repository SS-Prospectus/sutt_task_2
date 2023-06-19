import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sutt_task_2/Models/model.dart';
import 'dart:async';
import 'package:sutt_task_2/Storage%20and%20API/firebase_storage.dart';


Future<List<Movie>> fetchMoviesByTitle(String title) async {
  if(title==''){
    return Future(() => likedMovies);
  }
  final dio = Dio();
  final baseUrl = 'https://movies-tvshows-data-imdb.p.rapidapi.com/';
  final searchHeaders = {
    'X-RapidAPI-Key': '4b47ee4793mshfbc6900ce9e13ffp1f5404jsn685609031c9d',
    'Type' : 'get-movies-by-title',
    'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com',
  };

  final searchResponse = await dio.get(baseUrl,
      queryParameters: {'title' : title},
    options: Options(headers: searchHeaders)
  );

  if (searchResponse.statusCode == 200) {
    print('###');
    final List searchData = searchResponse.data['movie_results'];
    print(searchData);
    final List<Movie> movies = [];

    // Fetch details for each movie
    await completedetails(movies, searchData);
    print(movies);
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
      'X-RapidAPI-Key': '4b47ee4793mshfbc6900ce9e13ffp1f5404jsn685609031c9d',
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
              'X-RapidAPI-Key': '4b47ee4793mshfbc6900ce9e13ffp1f5404jsn685609031c9d',
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
        imagePath: imgresponse.data['poster'] == null|| imgresponse.data['poster']  == "" ? "https://www.google.com/imgres?imgurl=https%3A%2F%2Fst4.depositphotos.com%2F14953852%2F22772%2Fv%2F600%2Fdepositphotos_227725020-stock-illustration-image-available-icon-flat-vector.jpg&tbnid=PGT8-3oGI-qYcM&vet=12ahUKEwjy9Yvpks__AhUNH7cAHRS_CjAQMygDegUIARDIAQ..i&imgrefurl=https%3A%2F%2Fdepositphotos.com%2Fvector-images%2Fimage-not-available.html&docid=pCnF49UgDlu7sM&w=600&h=600&q=not%20available%20image&client=safari&ved=2ahUKEwjy9Yvpks__AhUNH7cAHRS_CjAQMygDegUIARDIAQ" : imgresponse.data['poster'],
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