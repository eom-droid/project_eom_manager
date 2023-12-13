const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

// IOS는 같은 PC라는 것으로 인지하지만 안드로이드는 다른 PC로 인식하기 때문에 로컬호스트 IP를 다르게 설정해줘야함
// android emulator 기준 localhost
const emulatorIp = '10.0.2.2:3001';
// ios simulator 기준 localhost
const simulatorIp = '127.0.0.1:3001';

// dev
// final ip = Platform.isIOS ? simulatorIp : emulatorIp;
// const ip = '13.124.101.120';
// const ip = '127.0.0.1:3001';

const accessToken = 'ProjectEomManagerAccessToken';

const NEW_ID = "NEW";

enum DiaryContentType {
  txt('txt', '텍스트'),
  img('img', '이미지'),
  vid('vid', '비디오');

  final String value;
  final String koreanValue;
  const DiaryContentType(this.value, this.koreanValue);

  factory DiaryContentType.getByCode(String code) {
    switch (code) {
      case 'txt':
        return DiaryContentType.txt;
      case 'img':
        return DiaryContentType.img;
      case 'vid':
        return DiaryContentType.vid;
      default:
        return DiaryContentType.txt;
    }
  }
}

enum DiaryCategory {
  daily('daily', '일상'),
  travel('travel', '여행'),
  study('study', '공부');

  final String value;
  final String koreanValue;
  const DiaryCategory(this.value, this.koreanValue);

  factory DiaryCategory.getByCode(String code) {
    switch (code) {
      case 'daily':
        return DiaryCategory.daily;
      case 'travel':
        return DiaryCategory.travel;
      case 'study':
        return DiaryCategory.study;
      default:
        return DiaryCategory.daily;
    }
  }
}

enum RoleType {
  user(0),
  manager(5),
  admin(10);

  final int value;
  const RoleType(this.value);
  factory RoleType.getByCode(int code) {
    switch (code) {
      case 0:
        return RoleType.user;
      case 5:
        return RoleType.manager;
      case 10:
        return RoleType.admin;
      default:
        return RoleType.user;
    }
  }
}

const paginationDefaultFetcgCount = 10;

const youtubeRatio = 0.56;

const homeBackgroundImageWidth = 1.599;
