import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/common/components/custom_sliver_app_bar.dart';
import 'package:manager/common/components/pagination_list_view.dart';
import 'package:manager/common/const/data.dart';
import 'package:manager/common/layout/defualt_sliver_appbar_listview_layout.dart';
import 'package:manager/common/model/cursor_pagination_model.dart';
import 'package:manager/common/model/pop_data_model.dart';
import 'package:manager/common/utils/data_utils.dart';
import 'package:manager/common/utils/ui_utils.dart';
import 'package:manager/diary/components/diary_card.dart';
import 'package:manager/diary/provider/diary_provider.dart';
import 'package:manager/diary/view/diary_detail_screen.dart';
import 'package:manager/diary/view/diary_edit_screen.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class DiaryScreen extends ConsumerWidget {
  static String get routeName => 'diary';
  DiaryScreen({super.key});

  Map<String, VideoPlayerController>? vidControllers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultSliverAppbarListviewLayout(
      sliverAppBar: _renderAppBar(context),
      onRefresh: () async {
        await ref.read(diaryProvider.notifier).paginate(forceRefetch: true);
      },
      onPressAdd: () {
        context.pushNamed(
          DiaryEditScreen.routeName,
          pathParameters: {'rid': NEW_ID},
        );
      },
      listview: PaginationListView(
        provider: diaryProvider,
        itemBuilder: <DiaryModel>(_, int index, model) {
          return Container();
        },
        customList: (CursorPagination cp) {
          return _renderDiaryList(
            cp: cp,
            ref: ref,
            context: context,
          );
        },
      ),
    );
  }

  Widget _renderAppBar(BuildContext context) {
    return const CustomSliverAppBar(
      title: "Diary",
      backgroundImgPath: "asset/imgs/diary/appbar_background.jpg",
      descriptionWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '옆에 한자리 남았어',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          Text(
            '뛰뛰빵빵',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderDiaryList({
    required CursorPagination cp,
    required WidgetRef ref,
    required BuildContext context,
  }) {
    final diaryList = cp.data;
    if (vidControllers == null) {
      vidControllers = {};
      for (var element in diaryList) {
        if (DataUtils.isVidFile(element.thumbnail!)) {
          vidControllers![element.id] = VideoPlayerController.network(
            element.thumbnail!,
          );
        }
      }
    }

    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: cp.data.length + 1,
        separatorBuilder: (context, index) => const Padding(
          padding: EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
          child: Divider(
            color: Colors.grey,
          ),
        ),
        itemBuilder: (_, index) {
          if (index == cp.data.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 64.0,
              ),
              child: Center(
                child: cp is CursorPaginationFetchingMore
                    ? const CircularProgressIndicator()
                    : const Text(
                        '마지막 입니다.',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    // color: const Color(0xFFD9D9D9).withOpacity(0.3),
                    color: Colors.black.withOpacity(0.7),
                    blurRadius: 3.0,
                    spreadRadius: 1,
                  ),
                ],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: InkWell(
                key: ValueKey(diaryList[index].id),
                onTap: () async {
                  context.pushNamed(
                    DiaryDetailScreen.routeName,
                    pathParameters: {'rid': diaryList[index].id},
                  );
                },
                child: DiaryCard.fromModel(
                  model: diaryList[index],
                  onThreeDotSelected: (int? value) {
                    threeDotSelected(
                      context: context,
                      diaryList: diaryList,
                      index: index,
                      ref: ref,
                      value: value,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  threeDotSelected({
    required int? value,
    required WidgetRef ref,
    required BuildContext context,
    required List<dynamic> diaryList,
    required int index,
  }) {
    if (value == 1) {
      toEditRoute(
        ref: ref,
        context: context,
        routeName: DiaryEditScreen.routeName,
        snackBarText: 'Diary updated!',
        id: diaryList[index].id,
      );
    } else if (value == 2) {
      UiUtils.showDeletePopUp(
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
              .deleteDiary(id: diaryList[index].id);

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
  }

  toEditRoute({
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
