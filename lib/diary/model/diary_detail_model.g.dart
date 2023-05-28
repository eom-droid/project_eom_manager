// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryDetailModel _$DiaryDetailModelFromJson(Map<String, dynamic> json) =>
    DiaryDetailModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      writer: json['writer'] as String,
      weather: json['weather'] as String,
      hashtags:
          (json['hashtags'] as List<dynamic>).map((e) => e as String).toList(),
      postDate: DataUtils.toLocalTimeZone(json['postDate'] as String),
      thumbnail: DataUtils.pathToUrl(json['thumbnail'] as String),
      category: json['category'] as String,
      isShown: json['isShown'] as bool,
      diaryId: json['diaryId'] as String,
      txts: (json['txts'] as List<dynamic>).map((e) => e as String).toList(),
      imgs: DataUtils.listPathsToUrls(json['imgs'] as List),
      vids: DataUtils.listPathsToUrls(json['vids'] as List),
      contentOrder: (json['contentOrder'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$DiaryDetailModelToJson(DiaryDetailModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'writer': instance.writer,
      'weather': instance.weather,
      'hashtags': instance.hashtags,
      'postDate': instance.postDate.toIso8601String(),
      'thumbnail': instance.thumbnail,
      'category': instance.category,
      'isShown': instance.isShown,
      'diaryId': instance.diaryId,
      'txts': instance.txts,
      'imgs': instance.imgs,
      'vids': instance.vids,
      'contentOrder': instance.contentOrder,
    };
