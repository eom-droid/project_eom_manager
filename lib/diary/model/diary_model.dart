import 'package:json_annotation/json_annotation.dart';
import 'package:manager/common/utils/data_utils.dart';

part 'diary_model.g.dart';

@JsonSerializable()
class DiaryModel {
  // id : 유일 아이디 값
  final String id;
  // title : 제목
  final String title;
  // writer : 작성자
  final String writer;
  // weather : 날씨
  final String weather;
  // hashtags : 해시태그 리스트
  final List<String> hashtags;
  // postDate : 표출 일자 -> 다이어리의 표출 일자, 사용자는 해당 값으로 ordering을 진행할 예정
  final DateTime postDate;
  // thumbnail : 썸네일 -> S3에 저장된 이미지, vid 의 경로
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String thumbnail;
  // category : 카테고리 -> 카테고리를 통해서 다이어리 리스트 페이지에서 필터링을 진행할 예정
  final String category;
  // isShown : 표출 여부
  final bool isShown;
  // regDTime : 등록 일자 -> 추후 mongoDB default 값 사용 예정
  final DateTime regDTime;
  // modDTime : 수정 일자 -> 추후 mongoDB default 값 사용 예정
  final DateTime modDTime;

  DiaryModel({
    required this.id,
    required this.title,
    required this.writer,
    required this.weather,
    required this.hashtags,
    required this.postDate,
    required this.thumbnail,
    required this.category,
    required this.isShown,
    required this.regDTime,
    required this.modDTime,
  });

  factory DiaryModel.empty() => DiaryModel(
        id: '',
        title: '',
        writer: '',
        weather: '',
        hashtags: [],
        postDate: DateTime.now(),
        thumbnail: '',
        category: '',
        isShown: true,
        regDTime: DateTime.now(),
        modDTime: DateTime.now(),
      );

  factory DiaryModel.fromJson(Map<String, dynamic> json) =>
      _$DiaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryModelToJson(this);
}
