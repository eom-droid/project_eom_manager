import 'dart:convert';

class DataUtils {
  static String pathToUrl(String value) {
    // return 'https://s3.ap-northeast-2.amazonaws.com/taeho-diary/$value';
    // 추후 s3에 업로드할 예정
    return value;
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

  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
