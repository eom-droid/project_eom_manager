import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/common/components/pagination_list_view.dart';
import 'package:manager/diary/components/diary_card.dart';
import 'package:manager/diary/provider/diary_provider.dart';
import 'package:manager/diary/view/diary_detail_screen.dart';

class DiaryScreen extends ConsumerWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginationListView(
      provider: diaryProvider,
      itemBuilder: <DiaryModel>(_, index, model) {
        return InkWell(
          onTap: () {
            context.pushNamed(
              DiaryDetailScreen.routeName,
              pathParameters: {'rid': model.id},
            );
          },
          child: DiaryCard.fromModel(
            model: model,
          ),
        );
      },
    );
  }
}
