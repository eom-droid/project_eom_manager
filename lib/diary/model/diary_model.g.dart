// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryModel _$DiaryModelFromJson(Map<String, dynamic> json) => DiaryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      writer: json['writer'] as String,
      weather: json['weather'] as String,
      hashtags:
          (json['hashtags'] as List<dynamic>).map((e) => e as String).toList(),
      postDate: DateTime.parse(json['postDate'] as String),
      thumnail: DataUtils.pathToUrl(json['thumnail'] as String),
      category: json['category'] as String,
      isShown: json['isShown'] as bool,
      regDTime: DateTime.parse(json['regDTime'] as String),
      modDTime: DateTime.parse(json['modDTime'] as String),
    );

Map<String, dynamic> _$DiaryModelToJson(DiaryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'writer': instance.writer,
      'weather': instance.weather,
      'hashtags': instance.hashtags,
      'postDate': instance.postDate.toIso8601String(),
      'thumnail': instance.thumnail,
      'category': instance.category,
      'isShown': instance.isShown,
      'regDTime': instance.regDTime.toIso8601String(),
      'modDTime': instance.modDTime.toIso8601String(),
    };
