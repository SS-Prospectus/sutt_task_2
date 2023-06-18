import 'package:dio/dio.dart';
import 'package:sutt_task_2/Models/model.dart';
import 'dart:async';


Future<List<Movie>> fetchMoviesByTitle(String title) async {
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
    print(searchData[0]['title']);
    final List<Movie> movies = [];

    // Fetch details for each movie
    await Future.forEach(searchData, (movie) async {
      final movieId = movie['imdb_id'];
      final detailsHeaders = {
        'X-RapidAPI-Key': '4b47ee4793mshfbc6900ce9e13ffp1f5404jsn685609031c9d',
        'Type' : 'get-movie-details',
        'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com',
      };

      final detailsResponse = await dio.get(
        baseUrl,
        options: Options(headers: detailsHeaders),
        queryParameters: {'movieid' : movieId}
      );

      final imgresponse = await dio.get(
        baseUrl,
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
          description: detailsResponse.data['description'],
          rating: detailsResponse.data['imdb_rating'],
          name: detailsResponse.data['title'],
          imagePath: imgresponse.data['poster'],
          videoPath: detailsResponse.data['youtube_trailer_key'],
          category: detailsResponse.data['rated'],
          year: detailsResponse.data['year'].toString(),
          duration: Duration(minutes: detailsResponse.data['runtime']),
          tagline: detailsResponse.data['tagline'],
        );

        movies.add(movie);
      } else {
        throw Exception('Failed to fetch movie details');
      }
    });
    print(movies);
    return movies;
  } else {
    throw Exception('Failed to fetch movies');
  }
}