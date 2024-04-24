// abstract class UserRepository

import 'package:manager/common/dio/dio.dart';
import 'package:manager/user/model/user_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'dart:convert';

part 'user_repository.g.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.read(dioProvider);

  String ip = dotenv.env['REST_API_BASE_URL']!;

  return UserRepository(dio, baseUrl: '$ip/api/v1/user');
});

@RestApi()
abstract class UserRepository {
  factory UserRepository(Dio dio, {String baseUrl}) = _UserRepository;

  @GET('/me')
  Future<UserModel?> getMe({
    @Header('authorization') required String accessTokenWithBearer,
  });

  @PATCH("/me/profile")
  @Headers({
    'accessToken': 'true',
  })
  @MultiPart()
  Future<UserModel> updateProfile({
    // @Body() required Map<String, dynamic> profile,
    @Part(name: "profile") required Map<String, dynamic> profile,
    @Part(name: "file") required List<MultipartFile> file,
  });
}
