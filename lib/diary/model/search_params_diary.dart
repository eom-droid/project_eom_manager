import 'package:json_annotation/json_annotation.dart';

part 'search_params_diary.g.dart';

// 추후 카테고리 지우기
@JsonSerializable()
class SearchParamsDiary {
  final DateTime? postDT;

  const SearchParamsDiary({
    this.postDT,
  });

  SearchParamsDiary copyWith({
    DateTime? postDT,
  }) {
    return SearchParamsDiary(
      postDT: postDT ?? this.postDT,
    );
  }

  Map<String, dynamic> toJson() => _$SearchParamsDiaryToJson(this);
}
