import 'package:json_annotation/json_annotation.dart';
import 'package:manager/common/model/pagination_params.dart';

part 'pagination_params_diary.g.dart';

// 추후 카테고리 지우기
@JsonSerializable()
class PaginationParamsDiary extends PaginationParamsBase {
  final String? category;
  final DateTime? postDT;
  final int? postDateInd;

  const PaginationParamsDiary({
    super.count,
    this.category,
    this.postDT,
    this.postDateInd,
  });

  PaginationParamsDiary copyWith({
    int? count,
    String? category,
    DateTime? postDT,
    int? postDateInd,
  }) {
    // 두개의 값이 동시에 있을때만 새로운 값으로 변경
    bool postDTAndPostDateIndIsNotNull = postDT != null && postDateInd != null;

    return PaginationParamsDiary(
      count: count ?? this.count,
      category: category ?? this.category,
      postDT: postDTAndPostDateIndIsNotNull ? postDT : this.postDT,
      postDateInd:
          postDTAndPostDateIndIsNotNull ? postDateInd : this.postDateInd,
    );
  }

  Map<String, dynamic> toJson() => _$PaginationParamsDiaryToJson(this);
}
