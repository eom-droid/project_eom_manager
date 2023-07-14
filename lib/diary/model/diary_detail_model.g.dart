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
      postDT: DataUtils.toLocalTimeZone(json['postDT'] as String),
      postDateInd: json['postDateInd'] as int,
      thumbnail: DataUtils.pathToUrl(json['thumbnail'] as String),
      category: DataUtils.stringToDiaryCategory(json['category'] as String),
      isShown: json['isShown'] as bool,
      txts: (json['txts'] as List<dynamic>).map((e) => e as String).toList(),
      imgs: DataUtils.listPathsToUrls(json['imgs'] as List),
      vids: DataUtils.listPathsToUrls(json['vids'] as List),
      contentOrder: DataUtils.listStringToListDiaryContentType(
          json['contentOrder'] as List),
    );

Map<String, dynamic> _$DiaryDetailModelToJson(DiaryDetailModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'writer': instance.writer,
      'weather': instance.weather,
      'hashtags': instance.hashtags,
      'postDT': instance.postDT.toIso8601String(),
      'postDateInd': instance.postDateInd,
      'thumbnail': instance.thumbnail,
      'category': DataUtils.diaryCategoryToString(instance.category),
      'isShown': instance.isShown,
      'txts': instance.txts,
      'imgs': instance.imgs,
      'vids': instance.vids,
      'contentOrder':
          DataUtils.listDiaryContentTypeToListString(instance.contentOrder),
    };
