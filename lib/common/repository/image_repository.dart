import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manager/common/dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'image_repository.g.dart';

final uploadRepositoryProvider = Provider<UploadRepository>((ref) {
  final dio = ref.read(dioProvider);
  String ip = dotenv.env['REST_API_BASE_URL']!;

  return UploadRepository(dio, baseUrl: '$ip/upload/diary/images');
});

@RestApi()
abstract class UploadRepository {
  factory UploadRepository(Dio dio, {String baseUrl}) = _UploadRepository;

  @POST('/')
  @Headers({
    'accessToken': 'true',
  })
  @MultiPart()
  Future<dynamic> uploadImage({
    @Part(name: "folderName") required String folderName,
    @Part(name: "files") required List<MultipartFile> files,
  });
}
