import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manager/diary/model/diary_detail_model.dart';
import 'package:manager/diary/model/diary_model.dart';
import 'package:collection/collection.dart';
import 'package:manager/diary/repository/diary_repository.dart';

final diaryDetailProvider = Provider.family<DiaryModel?, String>((ref, id) {
  final state = ref.watch(diaryProvider);

  //레스토랑 프로젝트에서 해당 줄을 추가하였는데 이유가 뭔지 궁금하네.....
  // if(state is! CursorPagination){
  //   return null;
  // }

  return state.firstWhereOrNull((element) => element.id == id);
});

final diaryProvider =
    StateNotifierProvider<DiaryNotifier, List<DiaryModel>>((ref) {
  final diaryRepository = ref.watch(diaryRepositoryProvider);
  return DiaryNotifier(
    diaryRepository: diaryRepository,
  );
});

class DiaryNotifier extends StateNotifier<List<DiaryModel>> {
  final DiaryRepository diaryRepository;

  DiaryNotifier({
    required this.diaryRepository,
  }) : super([]);

  Future<void> addDiary({
    required DiaryDetailModel diary,
    required List<MultipartFile> uploadFiles,
  }) async {
    print(await diaryRepository.addDiary(
      diary: diary.toJson(),
      file: uploadFiles,
    ));

    // print(await uploadRepository.uploadImage(
    //     folderName: 'diary/eom', files: uploadFiles));

    // uploadRepository.uploadImage(folderName: 'diary/eom', files: )
    // await repository.addDiary(diary: diary);
  }
}
