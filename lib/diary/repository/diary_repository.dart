// final diaryRepositoryProvider = Provider<>

import 'dart:convert';

import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manager/common/const/data.dart';
import 'package:manager/common/dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'diary_repository.g.dart';

final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  final dio = ref.read(dioProvider);
  return DiaryRepository(dio, baseUrl: 'http://$ip/api/v1/diary');
});

@RestApi()
abstract class DiaryRepository {
  factory DiaryRepository(Dio dio, {String baseUrl}) = _DiaryRepository;

  // @GET('/')
  // @Headers({
  //   'accessToken': 'true',
  // })
  // Future<DiaryModel> getDiary();

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
