import 'package:json_annotation/json_annotation.dart';
import 'package:manager/common/model/model_with_id.dart';

part 'music_model.g.dart';

@JsonSerializable()
class MusicModel implements IModelWithId {
  // id : 유일 아이디 값
  @override
  @JsonKey(name: '_id')
  final String id;
  // title : 노래 제목
  final String title;
  // artiste : 아티스트
  final String artiste;
  // review : 한줄평
  final String review;
  // albumCover : 앨범 커버
  final String albumCover;
  // youtubeLink : 유튜브 url
  final String youtubeLink;

  MusicModel({
    required this.id,
    required this.title,
    required this.artiste,
    required this.review,
    required this.albumCover,
    required this.youtubeLink,
  });

  factory MusicModel.empty() => MusicModel(
        id: '',
        title: '',
        artiste: '',
        review: '',
        albumCover: '',
        youtubeLink: '',
      );

  factory MusicModel.fromJson(Map<String, dynamic> json) =>
      _$MusicModelFromJson(json);

  Map<String, dynamic> toJson() => _$MusicModelToJson(this);
}
