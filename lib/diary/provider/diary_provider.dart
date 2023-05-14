import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manager/diary/model/diary_detail_model.dart';
import 'package:manager/diary/model/diary_model.dart';
import 'package:collection/collection.dart';
import 'package:manager/diary/repository/diary_repository.dart';

final diaryDetailProvider = Provider.family<DiaryModel, String>((ref, id) {
  final state = ref.watch(diaryProvider);

  //레스토랑 프로젝트에서 해당 줄을 추가하였는데 이유가 뭔지 궁금하네.....
  // if(state is! CursorPagination){
  //   return null;
  // }
  final DiaryModel? result =
      state.firstWhereOrNull((element) => element.id == id);
  if (result == null) {
    return DiaryModel.empty();
  }
  return result;
});

final diaryProvider =
    StateNotifierProvider<DiaryNotifier, List<DiaryModel>>((ref) {
  final repository = ref.watch(diaryRepositoryProvider);
  return DiaryNotifier(repository: repository);
});

class DiaryNotifier extends StateNotifier<List<DiaryModel>> {
  final DiaryRepository repository;

  DiaryNotifier({required this.repository}) : super([]);

  // void setDiary(DiaryDetailModel diary) {
  //   state = diary;
  // }

  Future<void> addDiary(DiaryDetailModel diary) async {
    print(await repository.addDiary(diary: diary));
  }
}
