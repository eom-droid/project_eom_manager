import 'dart:io';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

// IOS는 같은 PC라는 것으로 인지하지만 안드로이드는 다른 PC로 인식하기 때문에 로컬호스트 IP를 다르게 설정해줘야함
// android emulator 기준 localhost
const emulatorIp = '10.0.2.2:3001';
// ios simulator 기준 localhost
const simulatorIp = '127.0.0.1:3001';

final ip = Platform.isIOS ? simulatorIp : emulatorIp;

const accessToken = 'ProjectEomManagerAccessToken';

const NEW_ID = "NEW";

enum DiaryContentType {
  txt('txt', '텍스트'),
  img('img', '이미지'),
  vid('vid', '비디오');

  final String value;
  final String koreanValue;
  const DiaryContentType(this.value, this.koreanValue);
}

enum DiaryCategory {
  daily('daily', '일상'),
  travel('travel', '여행'),
  study('study', '공부');

  final String value;
  final String koreanValue;
  const DiaryCategory(this.value, this.koreanValue);
}
