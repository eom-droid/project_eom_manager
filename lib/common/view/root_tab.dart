import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/common/const/colors.dart';
import 'package:manager/common/layout/default_layout.dart';
import 'package:manager/diary/view/diary_add_screen.dart';
import 'package:manager/diary/view/diary_screen.dart';
import 'package:manager/home/view/home_screen.dart';
import 'package:manager/music/view/play_list_screen.dart';

class RootTab extends StatefulWidget {
  static String get routeName => 'home';
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller;
  FloatingActionButton? floatingActionButton;
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 3개의 탭을 가진 컨트롤러 생성
    // q: 아래 줄에서 vsync는 무슨 역할을 해?
    // a: vsync는 애니메이션을 동기화하는데 사용되는 객체
    controller = TabController(length: 3, vsync: this);
    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }

  void tabListener() {
    // tab 변경 작업 중에도 한번 불리는데 무시하기
    if (controller.indexIsChanging) {
      return;
    }
    // 탭 변경 floating button 추가
    switch (controller.index) {
      case 0:
        floatingActionButton = null;
        break;
      case 1 || 2:
        floatingActionButton = FloatingActionButton(
          onPressed: () {
            if (controller.index == 1) {
              context.pushNamed(DiaryAddScreen.routeName);
            } else {
              // context.pushNamed(DiaryAddScreen.routeName);
            }
          },
          child: const Icon(Icons.add),
        );
        break;
    }
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'Prj Eom',
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        // 선택 시 색상
        selectedItemColor: PRIMARY_COLOR,
        // 선택 시 폰트 사이즈
        selectedFontSize: 10.0,
        // 선택 안했을 때 색상
        unselectedItemColor: BODY_TEXT_COLOR,
        // 선택 안했을 때 폰트 사이즈
        unselectedFontSize: 10.0,
        // 선택 시 애니메이션
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: '일기장',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline_outlined),
            label: '플리',
          ),
        ],
      ),
      child: Center(
        child: TabBarView(
          // 좌우 스크롤 방지
          physics: const NeverScrollableScrollPhysics(),
          controller: controller,
          children: const [
            HomeScreen(),
            DiaryScreen(),
            PlayListScreen(),
          ],
        ),
      ),
    );
  }
}
