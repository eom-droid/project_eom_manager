import 'package:json_annotation/json_annotation.dart';
import 'package:manager/common/utils/data_utils.dart';
import 'package:manager/diary/model/diary_model.dart';

part 'diary_detail_model.g.dart';

@JsonSerializable()
class DiaryDetailModel extends DiaryModel {
  // diaryId : diary Id
  final String diaryId;

  // txts : 텍스트 리스트
  final List<String> txts;

  // imgs : 이미지 리스트
  @JsonKey(fromJson: DataUtils.listPathsToUrls)
  final List<String> imgs;

  // vids : 비디오 리스트 -> 초기에는 직접 로딩하지 않고
  @JsonKey(fromJson: DataUtils.listPathsToUrls)
  final List<String> vids;
  // contentOrder : 컨텐츠 순서
  // 추후 markdown 형식으로 저장할 예정
  // 현재는 위 3가지 txt,img,vid의 표출 순서를 정의
  final List<String> contentOrder;

  DiaryDetailModel({
    required super.id,
    required super.title,
    required super.writer,
    required super.weather,
    required super.hashtags,
    required super.postDate,
    required super.thumnail,
    required super.category,
    required super.isShown,
    required super.regDTime,
    required super.modDTime,
    required this.diaryId,
    required this.txts,
    required this.imgs,
    required this.vids,
    required this.contentOrder,
  });

  factory DiaryDetailModel.empty() => DiaryDetailModel(
        id: 'temp',
        title: 'temp',
        writer: '엄태호',
        weather: 'temp',
        hashtags: [],
        postDate: DateTime.now(),
        thumnail: 'temp',
        category: 'temp',
        isShown: true,
        regDTime: DateTime.now(),
        modDTime: DateTime.now(),
        diaryId: 'temp',
        txts: [],
        imgs: [],
        vids: [],
        contentOrder: [],
      );

  DiaryDetailModel copyWith({
    String? id,
    String? title,
    String? writer,
    String? weather,
    List<String>? hashtags,
    DateTime? postDate,
    String? thumnail,
    String? category,
    bool? isShown,
    DateTime? regDTime,
    DateTime? modDTime,
    String? diaryId,
    List<String>? txts,
    List<String>? imgs,
    List<String>? vids,
    List<String>? contentOrder,
  }) {
    return DiaryDetailModel(
      id: id ?? this.id,
      title: title ?? this.title,
      writer: writer ?? this.writer,
      weather: weather ?? this.weather,
      hashtags: hashtags ?? this.hashtags,
      postDate: postDate ?? this.postDate,
      thumnail: thumnail ?? this.thumnail,
      category: category ?? this.category,
      isShown: isShown ?? this.isShown,
      regDTime: regDTime ?? this.regDTime,
      modDTime: modDTime ?? this.modDTime,
      diaryId: diaryId ?? this.diaryId,
      txts: txts ?? this.txts,
      imgs: imgs ?? this.imgs,
      vids: vids ?? this.vids,
      contentOrder: contentOrder ?? this.contentOrder,
    );
  }

  factory DiaryDetailModel.fromJson(Map<String, dynamic> json) =>
      _$DiaryDetailModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DiaryDetailModelToJson(this);
}
