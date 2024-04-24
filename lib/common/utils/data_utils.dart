import 'dart:convert';

import 'package:manager/common/const/data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:manager/common/const/setting.dart';

class DataUtils {
  static String pathToUrl(String value) {
    String defaultAWSS3Url = dotenv.env['DefaultAWSS3Url']!;
    return "$defaultAWSS3Url/$value";
  }

  static String? pathToUrlNullable(String? value) {
    if (value != null) {
      String defaultAWSS3Url = dotenv.env['DefaultAWSS3Url']!;
      return "$defaultAWSS3Url/$value";
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

  static NumberFormat number2Unit = NumberFormat.compact(locale: "en_US");

  // 현재시각과의 차이가
  // 1분 이내 : 방금 전
  // 1시간 이내 : n분 전
  // 1일 이내 : n시간 전
  // 1주 이내 : n일 전
  // 1달 이내 : n주 전
  // 1년 이내 : n달 전
  // 1년 이상 : n년 전
  // DateTime을 매게변수로 받음

  static String timeAgoSinceDate(DateTime date) {
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if (difference.inMinutes < 0) {
      return '방금 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}주 전';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}달 전';
    } else {
      return '${(difference.inDays / 365).floor()}년 전';
    }
  }

  // 오늘 안에 포함되는 날짜면
  // "오후 1:00" 와 같이 표현하고
  // 어제 날짜면
  // "어제" 로 표현한다
  // 만약 어제가 아니고 오늘도 아니면
  // "1월 1일" 와 같이 표현한다
  // 만약 올해가 아니면
  // "2020.1.1" 와 같이 표현한다
  static String timeAgoSinceDate2(DateTime date) {
    final now = DateTime.now();

    if (now.day == date.day) {
      final hour = date.hour;
      final minute = date.minute;

      final hourStr = hour > 12 ? hour - 12 : hour;
      final minuteStr = minute < 10 ? "0$minute" : minute;

      final ampm = hour > 12 ? "오후" : "오전";

      return "$ampm $hourStr:$minuteStr";
    } else if (now.day - date.day == 1) {
      return "어제";
    } else if (now.year == date.year) {
      return DateFormat("M월 d일").format(date);
    } else {
      return DateFormat("yyyy.M.d").format(date);
    }
  }

  // DateTime to HH:mm
  static String dateTimeToHHmm(DateTime date) {
    final hour = date.hour;
    final minute = date.minute;

    final hourStr = hour > 12 ? hour - 12 : hour;
    final minuteStr = minute < 10 ? "0$minute" : minute;

    final ampm = hour > 12 ? "오후" : "오전";

    return "$ampm $hourStr:$minuteStr";
  }
}
