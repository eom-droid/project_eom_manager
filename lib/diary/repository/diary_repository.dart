// final diaryRepositoryProvider = Provider<>

import 'dart:convert';

import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manager/common/const/data.dart';
import 'package:manager/common/dio/dio.dart';
import 'package:manager/common/model/cursor_pagination_model.dart';
import 'package:manager/common/repository/base_pagination_repository.dart';
import 'package:manager/diary/model/diary_detail_model.dart';
import 'package:manager/diary/model/diary_model.dart';
import 'package:manager/diary/model/pagination_params_diary.dart';
import 'package:manager/diary/model/search_params_diary.dart';
import 'package:retrofit/retrofit.dart';

part 'diary_repository.g.dart';

final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  final dio = ref.read(dioProvider);
  String ip = dotenv.env['IP']!;

  return DiaryRepository(dio, baseUrl: 'http://$ip/api/v1/diaries');
});

@RestApi()
abstract class DiaryRepository
    implements IBasePaginationRepository<DiaryModel, PaginationParamsDiary> {
  factory DiaryRepository(Dio dio, {String baseUrl}) = _DiaryRepository;

  // diary pagination는
  @override
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<DiaryModel>> paginate({
    @Queries()
        PaginationParamsDiary? paginationParams = const PaginationParamsDiary(),
  });

  @GET('/{id}/detail')
  @Headers({
    'accessToken': 'true',
  })
  Future<DiaryDetailModel> getDiaryDetail({
    @Path() required String id,
  });

  @GET('/search')
  @Headers({
    'accessToken': 'true',
  })
  Future<bool> checkDiaryPostDTExist({
    @Queries() SearchParamsDiary? searchParam = const SearchParamsDiary(),
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

  @PATCH('/{id}')
  @Headers({
    'accessToken': 'true',
  })
  @MultiPart()
  Future<dynamic> updateDiary({
    @Path() required String id,
    @Part(name: "diary") required Map<String, dynamic> diary,
    @Part(name: "file") required List<MultipartFile> file,
  });

  @DELETE('/{id}')
  @Headers({
    'accessToken': 'true',
  })
  Future<dynamic> deleteDiary({
    @Path() required String id,
  });
}
