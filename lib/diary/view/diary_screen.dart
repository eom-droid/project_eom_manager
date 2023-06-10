import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/common/components/pagination_list_view.dart';
import 'package:manager/common/const/data.dart';
import 'package:manager/common/model/pop_data_model.dart';
import 'package:manager/diary/components/diary_card.dart';
import 'package:manager/diary/provider/diary_provider.dart';
import 'package:manager/diary/view/diary_detail_screen.dart';
import 'package:manager/diary/view/diary_edit_screen.dart';

class DiaryScreen extends ConsumerWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        PaginationListView(
          provider: diaryProvider,
          itemBuilder: <DiaryModel>(_, index, model) {
            return InkWell(
              onTap: () async {
                context.pushNamed(
                  DiaryDetailScreen.routeName,
                  pathParameters: {'rid': model.id},
                );
              },
              child: DiaryCard.fromModel(
                model: model,
                onTrheeDotSelected: (int? value) async {
                  if (value == 1) {
                    pushNamed(
                      ref: ref,
                      context: context,
                      routeName: DiaryEditScreen.routeName,
                      snackBarText: 'Diary updated!',
                    );
                  } else if (value == 2) {}
                },
              ),
            );
          },
        ),
        Positioned(
          bottom: 20,
          right: 0,
          child: FloatingActionButton(
            onPressed: () async {
              pushNamed(
                ref: ref,
                context: context,
                routeName: DiaryEditScreen.routeName,
                snackBarText: 'Diary added!',
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  pushNamed({
    required WidgetRef ref,
    required BuildContext context,
    required String routeName,
    required String snackBarText,
  }) async {
    final popData = await context.pushNamed<PopDataModel>(
      DiaryEditScreen.routeName,
      pathParameters: {'rid': NEW_ID},
    );
    if (popData != null && popData.refetch == true) {
      ref.read(diaryProvider.notifier).paginate(forceRefetch: true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Diary added!'),
        ),
      );
    }
  }
}
