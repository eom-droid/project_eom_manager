import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/common/components/pagination_list_view.dart';
import 'package:manager/common/const/colors.dart';
import 'package:manager/common/const/data.dart';
import 'package:manager/common/model/cursor_pagination_model.dart';
import 'package:manager/music/components/music_card.dart';
import 'package:manager/music/model/music_model.dart';
import 'package:manager/music/provider/music_provider.dart';
import 'package:manager/music/view/music_edit_screen.dart';

class MusicScreen extends ConsumerWidget {
  MusicScreen({super.key});
  final ScrollController _controller = ScrollController();

  SliverAppBar _renderAppBar() {
    return SliverAppBar(
      backgroundColor: COMMON_BLACK,
      // 맨 위에서 한계 이상으로 스크롤 했을때
      // 남는 공간을 차지
      stretch: true,
      // appBar의 길이
      expandedHeight: 500,
      // 사라질때의 크기
      collapsedHeight: 100,

      // 늘어났을때 어느것을 위치하고 싶은지
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    "asset/imgs/bg-img.jpg",
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colors.transparent,
                    COMMON_BLACK,
                  ],
                ),
              ),
            ),
            const Positioned(
              top: 130,
              left: 16,
              child: Text(
                '여기에 무언가 괜찮은\n것들을 넣어야\n뭐넣지',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  SliverList _renderMusicList(
    CursorPagination cp,
  ) {
    final musicList = cp.data as List<MusicModel>;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == cp.data.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 32.0,
              ),
              child: Center(
                child: cp is CursorPaginationFetchingMore
                    ? const CircularProgressIndicator()
                    : const Text('마지막 입니다.'),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
            ),
            child: MusicCard.fromModel(
              model: musicList[index],
            ),
          );
        },
        childCount: musicList.length + 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: COMMON_BLACK,
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              ref.read(musicProvider.notifier).paginate(forceRefetch: true);
            },
            child: PaginationListView(
              provider: musicProvider,
              itemBuilder: <MusicModel>(_, int index, model) {
                return MusicCard.fromModel(
                  model: model,
                );
              },
              customList: (CursorPagination cp) {
                return CustomScrollView(
                  controller: _controller,
                  slivers: [
                    _renderAppBar(),
                    _renderMusicList(cp),
                  ],
                );
              },
            ),
          ),
          Positioned(
            bottom: 20,
            right: 0,
            child: FloatingActionButton(
              onPressed: () async {
                context.pushNamed(
                  MusicEditScreen.routeName,
                  pathParameters: {'rid': NEW_ID},
                );
              },
              child: const Icon(Icons.add),
            ),
          )
        ],
      ),
    );
    // return CustomScrollView(
    //   slivers: [
    //     SliverAppBar(
    //       // true 시 스크롤 했을때 리스트의 중간에도 Appbar가 내려오게 할 수 있음.
    //       floating: true,
    //       // true 시 완전 고정
    //       pinned: false,
    //       // 자석 효과
    //       // floating이 true에만 사용가능
    //       snap: false,
    //       // 맨 위에서 한계 이상으로 스크롤 했을때
    //       // 남는 공간을 차지
    //       stretch: true,
    //       // appBar의 길이
    //       expandedHeight: 200,
    //       // 사라질때의 크기
    //       collapsedHeight: 100,
    //       // 늘어났을때 어느것을 위치하고 싶은지
    //       flexibleSpace: FlexibleSpaceBar(
    //         background: Image.asset(
    //           'asset/imgs/image_1.jpeg',
    //           fit: BoxFit.cover,
    //         ),
    //         title: const Text('FlexibleSpaceBar'),
    //       ),
    //       title: const Text('CustomScrollViewScreen'),
    //     ),
    //     SliverToBoxAdapter(
    //       child: SizedBox(
    //         height: MediaQuery.of(context).size.height,
    //         child: Padding(
    //           padding:
    //               const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    //           child: Stack(
    //             children: [
    //               PaginationListView(
    //                 provider: musicProvider,
    //                 itemBuilder: <MusicModel>(_, int index, model) {
    //                   return MusicCard.fromModel(
    //                     model: model,
    //                   );
    //                 },
    //               ),
    //               Positioned(
    //                 bottom: 20,
    //                 right: 0,
    //                 child: FloatingActionButton(
    //                   onPressed: () async {
    //                     context.pushNamed(
    //                       MusicEditScreen.routeName,
    //                       pathParameters: {'rid': NEW_ID},
    //                     );
    //                   },
    //                   child: const Icon(Icons.add),
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }

  // pushNamed({
  //   required WidgetRef ref,
  //   required BuildContext context,
  //   required String routeName,
  //   required String snackBarText,
  //   String? id,
  // }) async {
  //   final popData = await context.pushNamed<PopDataModel>(
  //     DiaryEditScreen.routeName,
  //     pathParameters: {'rid': id ?? NEW_ID},
  //   );
  //   if (popData != null && popData.refetch == true) {
  //     ref.read(diaryProvider.notifier).paginate(forceRefetch: true);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(snackBarText),
  //       ),
  //     );
  //   }
  // }
}
