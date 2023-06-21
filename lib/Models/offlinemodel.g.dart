// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offlinemodel.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $offlinemodelLocalAdapter on LocalAdapter<offlinemodel> {
  static final Map<String, RelationshipMeta> _kofflinemodelRelationshipMetas =
      {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kofflinemodelRelationshipMetas;

  @override
  offlinemodel deserialize(map) {
    map = transformDeserialize(map);
    return _$offlinemodelFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$offlinemodelToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _offlinemodelsFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $offlinemodelHiveLocalAdapter = HiveLocalAdapter<offlinemodel>
    with $offlinemodelLocalAdapter;

class $offlinemodelRemoteAdapter = RemoteAdapter<offlinemodel>
    with JsonServerAdapter<offlinemodel>;

final internalOfflinemodelsRemoteAdapterProvider =
    Provider<RemoteAdapter<offlinemodel>>((ref) => $offlinemodelRemoteAdapter(
        $offlinemodelHiveLocalAdapter(ref),
        InternalHolder(_offlinemodelsFinders)));

final offlinemodelsRepositoryProvider =
    Provider<Repository<offlinemodel>>((ref) => Repository<offlinemodel>(ref));

extension offlinemodelDataRepositoryX on Repository<offlinemodel> {
  JsonServerAdapter<offlinemodel> get jsonServerAdapter =>
      remoteAdapter as JsonServerAdapter<offlinemodel>;
}

extension offlinemodelRelationshipGraphNodeX
    on RelationshipGraphNode<offlinemodel> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

offlinemodel _$offlinemodelFromJson(Map<String, dynamic> json) => offlinemodel(
      movie_result: json['movie_result'] as List<dynamic>,
      status: json['status'] as String?,
      status_message: json['status_message'] as String?,
      search_result: json['search_result'] as int?,
      id: json['id'] as int?,
    );

Map<String, dynamic> _$offlinemodelToJson(offlinemodel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'movie_result': instance.movie_result,
      'status_message': instance.status_message,
      'search_result': instance.search_result,
      'status': instance.status,
    };
