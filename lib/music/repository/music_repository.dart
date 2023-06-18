import 'dart:convert';

import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manager/common/const/data.dart';
import 'package:manager/common/dio/dio.dart';
import 'package:manager/common/model/cursor_pagination_model.dart';
import 'package:manager/common/model/pagination_params.dart';
import 'package:manager/common/repository/base_pagination_repository.dart';

import 'package:manager/music/model/music_model.dart';
import 'package:retrofit/retrofit.dart';

part 'music_repository.g.dart';

final musicRepositoryProvider = Provider<MusicRepository>((ref) {
  final dio = ref.read(dioProvider);
  return MusicRepository(dio, baseUrl: 'http://$ip/api/v1/musics');
});

@RestApi()
abstract class MusicRepository
    implements IBasePaginationRepository<MusicModel, PaginationParams> {
  factory MusicRepository(Dio dio, {String baseUrl}) = _MusicRepository;

  // music pagination는
  @override
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<MusicModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  // @GET('/{id}')
  // @Headers({
  //   'accessToken': 'true',
  // })
  // Future<MusicModel> getMusicDetail({
  //   @Path() required String id,
  // });

  @POST('/')
  @Headers({
    'accessToken': 'true',
  })
  @MultiPart()
  Future<dynamic> addMusic({
    @Part(name: "music") required Map<String, dynamic> music,
    @Part(name: "file") required List<MultipartFile> file,
  });

  @PATCH('/{id}')
  @Headers({
    'accessToken': 'true',
  })
  @MultiPart()
  Future<dynamic> updateMusic({
    @Path() required String id,
    @Part(name: "music") required Map<String, dynamic> music,
    @Part(name: "file") required List<MultipartFile> file,
  });

  @DELETE('/{id}')
  @Headers({
    'accessToken': 'true',
  })
  Future<dynamic> deleteMusic({
    @Path() required String id,
  });
}
