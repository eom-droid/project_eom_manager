// final diaryRepositoryProvider = Provider<>

import 'dart:convert';

import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manager/common/const/data.dart';
import 'package:manager/common/dio/dio.dart';
import 'package:manager/common/model/cursor_pagination_model.dart';
import 'package:manager/common/model/pagination_params.dart';
import 'package:manager/common/repository/base_pagination_repository.dart';
import 'package:manager/diary/model/diary_detail_model.dart';
import 'package:manager/diary/model/diary_model.dart';
import 'package:retrofit/retrofit.dart';

part 'diary_repository.g.dart';

final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  final dio = ref.read(dioProvider);
  return DiaryRepository(dio, baseUrl: 'http://$ip/api/v1/diaries');
});

@RestApi()
abstract class DiaryRepository
    implements IBasePaginationRepository<DiaryModel> {
  factory DiaryRepository(Dio dio, {String baseUrl}) = _DiaryRepository;

  @override
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<DiaryModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  @GET('/{id}')
  @Headers({
    'accessToken': 'true',
  })
  Future<DiaryDetailModel> getDiaryDetail({
    @Path() required String id,
  });

  @POST('/')
  @Headers({
    'accessToken': 'true',
  })
  @MultiPart()
  Future<dynamic> addDiary({
    @Part(name: "diary") required Map<String, dynamic> diary,
    @Part(name: "file") required List<MultipartFile> file,
  });
}
