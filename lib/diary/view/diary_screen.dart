import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/common/components/pagination_list_view.dart';
import 'package:manager/common/const/colors.dart';
import 'package:manager/common/const/data.dart';
import 'package:manager/common/model/cursor_pagination_model.dart';
import 'package:manager/common/model/pop_data_model.dart';
import 'package:manager/common/utils/data_utils.dart';
import 'package:manager/diary/components/diary_card.dart';
import 'package:manager/diary/provider/diary_provider.dart';
import 'package:manager/diary/view/diary_detail_screen.dart';
import 'package:manager/diary/view/diary_edit_screen.dart';
import 'package:video_player/video_player.dart';

class DiaryScreen extends ConsumerWidget {
  static String get routeName => 'diary';
  DiaryScreen({super.key});
  final ScrollController _controller = ScrollController();
  Map<String, VideoPlayerController>? vidControllers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: BACKGROUND_BLACK,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              ref.read(diaryProvider.notifier).paginate(forceRefetch: true);
            },
            child: PaginationListView(
              provider: diaryProvider,
              itemBuilder: <DiaryModel>(_, int index, model) {
                return DiaryCard.fromModel(
                  model: model,
                  onThreeDotSelected: (int? value) {},
                );
              },
              customList: (CursorPagination cp) {
                return CustomScrollView(
                  controller: _controller,
                  slivers: [
                    _renderAppBar(context),
                    _renderDiaryList(cp, ref),
                  ],
                );
              },
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom,
            right: 20.0,
            child: FloatingActionButton(
              onPressed: () async {
                context.pushNamed(
                  DiaryEditScreen.routeName,
                  pathParameters: {'rid': NEW_ID},
                );
              },
              child: const Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }

  SliverAppBar _renderAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: BACKGROUND_BLACK,
      // 맨 위에서 한계 이상으로 스크롤 했을때
      // 남는 공간을 차지
      stretch: true,
      // appBar의 길이
      expandedHeight: MediaQuery.of(context).size.width -
          MediaQuery.of(context).padding.top,
      // 상단 고정
      pinned: true,

      // 늘어났을때 어느것을 위치하고 싶은지
      flexibleSpace: FlexibleSpaceBar(
        // centerTitle: false,

        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Diary',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'sabreshark',
                fontSize: 20.0,
              ),
            ),
            SizedBox(width: 16.0),
          ],
        ),
        background: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.bottomLeft,
                  fit: BoxFit.cover,
                  image: AssetImage(
                    "asset/imgs/diary/appbar_background.jpg",
                  ),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomRight,
            //       colors: <Color>[
            //         Colors.transparent,
            //         BACKGROUND_BLACK.withOpacity(0.6),
            //         BACKGROUND_BLACK,
            //       ],
            //     ),
            //   ),
            // ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 60,
              left: 16,
              child: const Column(
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
            ),
          ],
        ),
      ),
    );
  }

  SliverPadding _renderDiaryList(
    CursorPagination cp,
    WidgetRef ref,
  ) {
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

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      sliver: SliverList.separated(
          itemCount: cp.data.length + 1,
          separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
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
                top: 16.0,
              ),
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
                    onThreeDotSelected: (int? value) async {
                      if (value == 1) {
                        editRoute(
                          ref: ref,
                          context: context,
                          routeName: DiaryEditScreen.routeName,
                          snackBarText: 'Diary updated!',
                          id: diaryList[index].id,
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
                    },
                  ),
                ),
              ),
            );
          }),
    );

    // return Scaffold(
    //   backgroundColor: BACKGROUND_BLACK,
    //   body: Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //     child: Stack(
    //       children: [
    //         PaginationListView<DiaryModel>(
    //           provider: diaryProvider,
    //           itemBuilder: <DiaryModel>(_, int index, model) {
    //             return InkWell(
    //               onTap: () async {
    //                 context.pushNamed(
    //                   DiaryDetailScreen.routeName,
    //                   pathParameters: {'rid': model.id},
    //                 );
    //               },
    //               child: DiaryCard.fromModel(
    //                 model: model,
    //                 onTrheeDotSelected: (int? value) async {
    //                   if (value == 1) {
    //                     pushNamed(
    //                       ref: ref,
    //                       context: context,
    //                       routeName: DiaryEditScreen.routeName,
    //                       snackBarText: 'Diary updated!',
    //                       id: model.id,
    //                     );
    //                   } else if (value == 2) {
    //                     showPopUp(
    //                       context: context,
    //                       onConfirm: () async {
    //                         showDialog(
    //                           context: context,
    //                           barrierDismissible: false,
    //                           builder: (BuildContext context) {
    //                             return const AlertDialog(
    //                               title: Text('삭제중입니다.'),
    //                               content: LinearProgressIndicator(),
    //                             );
    //                           },
    //                         );
    //                         await ref
    //                             .read(diaryProvider.notifier)
    //                             .deleteDiary(id: model.id);

    //                         // 위에서 다이얼로그를 하나 더 열기때문에
    //                         // pop을 하나더 진행함
    //                         Navigator.of(context).pop();
    //                         Navigator.of(context).pop();
    //                       },
    //                       onCancel: () {
    //                         Navigator.of(context).pop();
    //                       },
    //                     );
    //                   }
    //                 },
    //               ),
    //             );
    //           },
    //         ),
    //         Positioned(
    //           bottom: MediaQuery.of(context).padding.bottom + 16.0,
    //           right: 0,
    //           child: FloatingActionButton(
    //             onPressed: () async {
    //               pushNamed(
    //                 ref: ref,
    //                 context: context,
    //                 routeName: DiaryEditScreen.routeName,
    //                 snackBarText: 'Diary added!',
    //               );
    //             },
    //             child: const Icon(Icons.add),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
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

  editRoute({
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
