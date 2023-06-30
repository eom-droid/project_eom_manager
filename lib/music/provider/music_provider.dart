import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manager/common/model/cursor_pagination_model.dart';
import 'package:manager/common/model/pagination_params.dart';
import 'package:manager/common/provider/pagination_provider.dart';
import 'package:manager/music/model/music_model.dart';
import 'package:manager/music/repository/music_repository.dart';

final musicDetailProvider = Provider.family<MusicModel?, String>((ref, id) {
  final state = ref.watch(musicProvider);

  if (state is! CursorPagination) {
    return null;
  }

  return state.data.firstWhereOrNull((element) => element.id == id);
});

final musicProvider =
    StateNotifierProvider<MusicStateNotifier, CursorPaginationBase>((ref) {
  final musicRepository = ref.watch(musicRepositoryProvider);
  return MusicStateNotifier(
    repository: musicRepository,
  );
});

class MusicStateNotifier
    extends PaginationProvider<MusicModel, MusicRepository, PaginationParams> {
  MusicStateNotifier({
    required super.repository,
  });

  MusicModel getMusicById(String id) {
    if (state is! CursorPagination) {
      return MusicModel.empty();
    }

    final pState = state as CursorPagination;

    return pState.data.firstWhere((element) => element.id == id);
  }

  Future<void> addMusic({
    required MusicModel music,
    required MultipartFile thumbnail,
  }) async {
    await super.repository.addMusic(
      music: music.toJson(),
      file: [thumbnail],
    );
  }

  Future<void> updateMusic({
    required MusicModel music,
    required MultipartFile thumbnail,
  }) async {
    await super.repository.updateMusic(
      id: music.id,
      music: music.toJson(),
      file: [thumbnail],
    );
  }

  Future<void> deleteMusic({
    required String id,
  }) async {
    await super.repository.deleteMusic(id: id);

    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;

    state = pState.copyWith(
      data: pState.data.where((element) => element.id != id).toList(),
    );
  }
}
