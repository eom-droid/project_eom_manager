// final diaryRepositoryProvider = Provider<>

import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manager/common/const/data.dart';
import 'package:manager/common/dio/dio.dart';
import 'package:manager/diary/model/diary_detail_model.dart';
import 'package:retrofit/retrofit.dart';

part 'diary_repository.g.dart';

final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  final dio = ref.read(dioProvider);
  return DiaryRepository(dio, baseUrl: 'http://$ip/diary');
});

@RestApi()
abstract class DiaryRepository {
  factory DiaryRepository(Dio dio, {String baseUrl}) = _DiaryRepository;

  @POST('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<dynamic> addDiary({
    @Body() required DiaryDetailModel diary,
  });
}
