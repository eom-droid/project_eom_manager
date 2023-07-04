import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/common/components/pagination_list_view.dart';
import 'package:manager/common/const/data.dart';
import 'package:manager/common/model/pop_data_model.dart';
import 'package:manager/diary/components/diary_card.dart';
import 'package:manager/diary/model/diary_model.dart';
import 'package:manager/diary/provider/diary_provider.dart';
import 'package:manager/diary/view/diary_detail_screen.dart';
import 'package:manager/diary/view/diary_edit_screen.dart';

class DiaryScreen extends ConsumerWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        children: [
          PaginationListView<DiaryModel>(
            provider: diaryProvider,
            itemBuilder: <DiaryModel>(_, int index, model) {
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
                        id: model.id,
                      );
                    } else if (value == 2) {
                      showPopUp(
                        context: context,
                        onConfirm: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                title: Text('삭제중입니다.'),
                                content: LinearProgressIndicator(),
                              );
                            },
                          );
                          await ref
                              .read(diaryProvider.notifier)
                              .deleteDiary(id: model.id);

                          // 위에서 다이얼로그를 하나 더 열기때문에
                          // pop을 하나더 진행함
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        onCancel: () {
                          Navigator.of(context).pop();
                        },
                      );
                    }
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
      ),
    );
  }

  showPopUp({
    required BuildContext context,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('삭제하시겠습니까?'),
          // 컨텐츠 영역
          // content: ,
          actions: <Widget>[
            TextButton(
              onPressed: onConfirm,
              child: const Text('넵'),
            ),
            TextButton(
              onPressed: onCancel,
              child: const Text('아뇨'),
            ),
          ],
        );
      },
    );
  }

  pushNamed({
    required WidgetRef ref,
    required BuildContext context,
    required String routeName,
    required String snackBarText,
    String? id,
  }) async {
    final popData = await context.pushNamed<PopDataModel>(
      DiaryEditScreen.routeName,
      pathParameters: {'rid': id ?? NEW_ID},
    );
    if (popData != null && popData.refetch == true) {
      ref.read(diaryProvider.notifier).paginate(forceRefetch: true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackBarText),
        ),
      );
    }
  }
}
