import 'dart:async';
import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sutt_task_2/Logic/userprovider.dart';

part 'offlinemodel.g.dart';

@JsonSerializable()
@DataRepository([JsonServerAdapter])
class offlinemodel extends DataModel<offlinemodel> {

  @override
  final int? id;
  final List<dynamic> movie_result;
  final String? status_message ;
  final int? search_result ;
  final String? status;

  offlinemodel({required this.movie_result, required this.status, this.status_message,required this.search_result, this.id});

  static List<offlinemodel>fromResultJson(dynamic jsonResult) {
    var movies = jsonResult as List<dynamic>;
    var result = movies.map<offlinemodel>((response) =>
        offlinemodel(
          movie_result: response['movie_result'],
          status: response['status'],
          status_message: response['status_message'],
          search_result: response['search_result'],
    )).toList();
    return result;
  }
}

mixin JsonServerAdapter<T extends DataModel<T>> on RemoteAdapter<T> {
  @override
  FutureOr<Map<String, String>> get defaultHeaders async {
    return {
      'X-RapidAPI-Key': '4b47ee4793mshfbc6900ce9e13ffp1f5404jsn685609031c9d',
      'Type' : 'get-movies-by-title',
      'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com',
    };
  }

  @override
  String urlForFindAll(Map<String, dynamic> params) {
    String title = 'superman';
    return 'https://movies-tvshows-data-imdb.p.rapidapi.com/?title=$title';
  }

  @override
  String get baseUrl => 'https://movies-tvshows-data-imdb.p.rapidapi.com/';
}