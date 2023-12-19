import 'package:json_annotation/json_annotation.dart';
import 'package:manager/common/const/data.dart';
import 'package:manager/common/model/model_with_id.dart';
import 'package:manager/common/utils/data_utils.dart';

part 'diary_model.g.dart';

@JsonSerializable()
class DiaryModel implements IModelWithId {
  // id : 유일 아이디 값
  @override
  @JsonKey(name: '_id')
  final String id;
  // title : 제목
  final String title;
  // writer : 작성자
  final String writer;
  // weather : 날씨
  final String weather;
  // hashtags : 해시태그 리스트
  final List<String> hashtags;

  // thumbnail : 썸네일 -> S3에 저장된 이미지, vid 의 경로
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String thumbnail;
  @JsonKey(
    fromJson: DataUtils.stringToDiaryCategory,
    toJson: DataUtils.diaryCategoryToString,
  )
  // category : 카테고리 -> 카테고리를 통해서 다이어리 리스트 페이지에서 필터링을 진행할 예정
  final DiaryCategory category;
  // isShown : 표출 여부
  final bool isShown;
  // createdAt : 생성 일자
  // read 해오는 경우 서버에서 UTC로 보내주기 때문에 local time zone으로 변경
  // write 경우는 따로 파싱을 하지 않음 -> 서버에서 저장 시 MongoDB가 자체적으로 UTC로 변경하여 저장
  @JsonKey(
    defaultValue: null,
    fromJson: DataUtils.toLocalTimeZone,
  )
  final DateTime createdAt;

  DiaryModel({
    required this.id,
    required this.title,
    required this.writer,
    required this.weather,
    required this.hashtags,
    required this.thumbnail,
    required this.category,
    required this.isShown,
    required this.createdAt,
  });

  factory DiaryModel.empty() => DiaryModel(
        id: '',
        title: '',
        writer: '',
        weather: '',
        hashtags: [],
        thumbnail: '',
        category: DiaryCategory.daily,
        isShown: true,
        createdAt: DateTime.now(),
      );

  factory DiaryModel.fromJson(Map<String, dynamic> json) =>
      _$DiaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryModelToJson(this);
}
