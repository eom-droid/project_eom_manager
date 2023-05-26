import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manager/diary/components/diary_card.dart';
import 'package:manager/diary/provider/diary_provider.dart';

class DiaryScreen extends ConsumerWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diaryState = ref.watch(diaryProvider);

    if (diaryState.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.separated(
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemBuilder: (context, index) {
          return DiaryCard.fromModel(
            model: diaryState[index],
          );
        },
        itemCount: diaryState.length,
      );
    }
  }
}
