import 'dart:convert';

import 'package:manager/common/const/data.dart';
import 'package:manager/common/const/setting.dart';

class DataUtils {
  static String pathToUrl(String value) {
    // return 'https://s3.ap-northeast-2.amazonaws.com/taeho-diary/$value';
    // 추후 s3에 업로드할 예정
    return defaultAWSS3Url + value;
  }

  static String? pathToUrlNullable(String? value) {
    if (value != null) {
      return defaultAWSS3Url + value;
    } else {
      return null;
    }
  }

  static RoleType numberToRoleType(int value) {
    return RoleType.getByCode(value);
  }

  static List<String> listPathsToUrls(List paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }

  static String plainToBase64(String plane) {
    // 어떻게 인코딩을 할지 정의
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    // 인코딩
    String encdoded = stringToBase64.encode(plane);

    return encdoded;
  }

  static DateTime stringToDateTime(String value) {
    return DateTime.parse(value);
  }

  static DateTime toLocalTimeZone(String value) {
    return stringToDateTime(value).toLocal();
    // return value.toLocal();
  }

  static List<DiaryContentType> listStringToListDiaryContentType(
      List<dynamic> value) {
    return value.map((e) => DiaryContentType.getByCode(e)).toList();
  }

  static List<String> listDiaryContentTypeToListString(
      List<DiaryContentType> value) {
    return value.map((e) => e.value).toList();
  }

  static DiaryCategory stringToDiaryCategory(String value) {
    return DiaryCategory.getByCode(value);
  }

  static String diaryCategoryToString(DiaryCategory value) {
    return value.value;
  }

  static String urlToPath(String value) {
    return value.replaceAll(defaultAWSS3Url, '');
  }

  static bool isImgFile(String filePath) {
    final imageFileExtension = [
      "jpg",
      "jpeg",
      "png",
      "gif",
      "bmp",
      "JPG",
      "JPEG",
      "PNG",
      "GIF",
      "BMP",
    ];

    final fileExtension = filePath.split('.').last;
    return imageFileExtension.contains(fileExtension);
  }

  static bool isVidFile(String filePath) {
    final videoFileExtension = [
      "mp4",
      "MP4",
      "avi",
      "AVI",
      "wmv",
      "WMV",
      "mov",
      "MOV",
    ];

    final fileExtension = filePath.split('.').last;
    return videoFileExtension.contains(fileExtension);
  }

  static bool isEmailValid(String email) {
    final emailRegExp = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailRegExp;
  }
}
