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
  static String get routeName => 'music';
  MusicScreen({super.key});
  final ScrollController _controller = ScrollController();

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
              'PlayList',
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
                    "asset/imgs/music/appbar_background.jpg",
                  ),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colors.transparent,
                    BACKGROUND_BLACK.withOpacity(0.6),
                    BACKGROUND_BLACK,
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 60,
              left: 16,
              child: const Column(
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
            ),
          ],
        ),
      ),
    );
  }

  SliverPadding _renderMusicList(
    CursorPagination cp,
  ) {
    final musicList = cp.data as List<MusicModel>;
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
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

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 32.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.8),
                        blurRadius: 1,
                        spreadRadius: 3,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: MusicCard.fromModel(
                    model: musicList[index],
                  ),
                ),
              ),
            );
          },
          childCount: musicList.length + 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: BACKGROUND_BLACK,
      body: Stack(
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
                    _renderAppBar(context),
                    _renderMusicList(cp),
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
  }
}
