import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/common/components/custom_sliver_app_bar.dart';
import 'package:manager/common/components/pagination_list_view.dart';
import 'package:manager/common/const/data.dart';
import 'package:manager/common/layout/defualt_sliver_appbar_listview_layout.dart';
import 'package:manager/common/model/cursor_pagination_model.dart';
import 'package:manager/common/model/pop_data_model.dart';
import 'package:manager/common/utils/ui_utils.dart';
import 'package:manager/music/components/music_card.dart';
import 'package:manager/music/model/music_model.dart';
import 'package:manager/music/provider/music_provider.dart';
import 'package:manager/music/view/music_edit_screen.dart';

class MusicScreen extends ConsumerWidget {
  static String get routeName => 'music';
  const MusicScreen({super.key});

  Widget _renderAppBar(BuildContext context) {
    return const CustomSliverAppBar(
      title: "PlayList",
      backgroundImgPath: "asset/imgs/music/appbar_background.jpg",
      descriptionWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '가끔 먹어야 맛있는',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '감자알칩',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
              SizedBox(width: 8.0),
              Text(
                '같은',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _renderMusicList({
    required BuildContext context,
    required CursorPagination cp,
    required WidgetRef ref,
  }) {
    final musicList = cp.data as List<MusicModel>;
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
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
            padding: const EdgeInsets.only(
              top: 32.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 5,
                    spreadRadius: 4,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: MusicCard.fromModel(
                model: musicList[index],
                onThreeDotSelected: (int? value) {
                  threeDotSelected(
                    context: context,
                    diaryList: musicList,
                    index: index,
                    ref: ref,
                    value: value,
                  );
                },
              ),
            ),
          );
        },
        itemCount: musicList.length + 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultSliverAppbarListviewLayout(
      sliverAppBar: _renderAppBar(context),
      onRefresh: () async {
        await ref.read(musicProvider.notifier).paginate(forceRefetch: true);
      },
      onPressAdd: () {
        context.pushNamed(
          MusicEditScreen.routeName,
          pathParameters: {'rid': NEW_ID},
        );
      },
      listview: PaginationListView(
        provider: musicProvider,
        itemBuilder: <MusicModel>(_, int index, model) {
          return Container();
        },
        customList: (CursorPagination cp) {
          return _renderMusicList(
            context: context,
            cp: cp,
            ref: ref,
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
        routeName: MusicEditScreen.routeName,
        snackBarText: 'Music updated!',
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
              .read(musicProvider.notifier)
              .deleteMusic(id: diaryList[index].id);

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
      MusicEditScreen.routeName,
      pathParameters: {'rid': id ?? NEW_ID},
    );
    await Future.delayed(const Duration(milliseconds: 500), () {});
    if (popData != null && popData.refetch == true) {
      ref.read(musicProvider.notifier).paginate(forceRefetch: true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackBarText),
        ),
      );
    }
  }
}
