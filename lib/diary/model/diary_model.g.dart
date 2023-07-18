// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryModel _$DiaryModelFromJson(Map<String, dynamic> json) => DiaryModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      writer: json['writer'] as String,
      weather: json['weather'] as String,
      hashtags:
          (json['hashtags'] as List<dynamic>).map((e) => e as String).toList(),
      postDT: DataUtils.toLocalTimeZone(json['postDT'] as String),
      thumbnail: DataUtils.pathToUrl(json['thumbnail'] as String),
      category: DataUtils.stringToDiaryCategory(json['category'] as String),
      isShown: json['isShown'] as bool,
    );

Map<String, dynamic> _$DiaryModelToJson(DiaryModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'writer': instance.writer,
      'weather': instance.weather,
      'hashtags': instance.hashtags,
      'postDT': instance.postDT.toIso8601String(),
      'thumbnail': instance.thumbnail,
      'category': DataUtils.diaryCategoryToString(instance.category),
      'isShown': instance.isShown,
    };
