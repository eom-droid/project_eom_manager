import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manager/diary/model/diary_model.dart';

final selectedDiaryProvider =
    StateNotifierProvider<SelectedDiaryNotifier, DiaryDetailModel>(
        (ref) => SelectedDiaryNotifier());

class SelectedDiaryNotifier extends StateNotifier<DiaryDetailModel> {
  SelectedDiaryNotifier() : super(DiaryDetailModel.empty());

  void setDiary(DiaryDetailModel diary) {
    state = diary;
  }

  void updateDiary(DiaryDetailModel diary) {
    state = diary.copyWith();
  }

  void updateDetial(String a) {
    List<String> temp = state.contentOrder;
    temp.add(a);
    state = state.copyWith(contentOrder: temp);
  }
}
