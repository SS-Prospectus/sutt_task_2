import 'dart:async';
import 'dart:convert';
import 'package:flutter_data/flutter_data.dart';
import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';
import 'model.dart';
import 'package:sutt_task_2/Logic/userprovider.dart';

part 'offlinemodel.g.dart';

@JsonSerializable()
@DataRepository([JsonServerAdapter])
class offlinemodel extends DataModel<offlinemodel> {

  @override
  final int? id;
  final String title ;
  final int? year ;
  final String imdbid;

  offlinemodel({required this.title, required this.imdbid, this.year, this.id});
}

mixin JsonServerAdapter<T extends DataModel<T>> on RemoteAdapter<T> {
 @override
  String get baseUrl => 'https://movies-tvshows-data-imdb.p.rapidapi.com/';

 @override
  String urlForFindAll(Map<String,dynamic> params) => ref.read(searchqueryProvider);

 @override
  FutureOr<Map<String, String>> get defaultHeaders async {
   return await super.defaultHeaders & {
     'X-RapidAPI-Key': '4b47ee4793mshfbc6900ce9e13ffp1f5404jsn685609031c9d',
      'Type' : 'get-movies-by-title',
      'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com',
     };
  }
}