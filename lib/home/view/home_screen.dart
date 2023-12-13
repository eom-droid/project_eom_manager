import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/common/const/data.dart';
import 'package:manager/common/const/setting.dart';
import 'dart:math' as math;

import 'package:manager/diary/view/diary_screen.dart';
import 'package:manager/home/components/routing_button.dart';
import 'package:manager/music/view/music_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),
          BackgroundFilter(),
          _FrontImagesRender(),
        ],
      ),
    );
  }
}

class BackgroundImage extends StatefulWidget {
  const BackgroundImage({super.key});

  @override
  State<BackgroundImage> createState() => _BackgroundImageState();
}

class _BackgroundImageState extends State<BackgroundImage>
    with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    duration: const Duration(seconds: 120),
    vsync: this,
    value: 0.0,
    lowerBound: 0.0,
    upperBound:
        (homeBackgroundImageWidth * MediaQuery.of(context).size.height) -
            (MediaQuery.of(context).size.width),
  )..repeat(reverse: true);

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: ((context, child) {
        return Positioned(
          left: -_animationController.value,
          child: child!,
        );
      }),
      child: Image.asset(
        "asset/imgs/home_background.png",
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.contain,
      ),
    );
  }
}

class BackgroundFilter extends StatelessWidget {
  const BackgroundFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD9D9D9).withOpacity(0.1),
    );
  }
}

class _FrontImagesRender extends StatelessWidget {
  const _FrontImagesRender();

  @override
  Widget build(BuildContext context) {
    final aspectWidth = MediaQuery.of(context).size.width / defaultWidth;
    List<int> middleImageList = List.generate(
        (MediaQuery.of(context).size.width / 40).ceil(), (index) => index);

    return SafeArea(
      top: true,
      bottom: false,
      left: false,
      right: false,
      child: Stack(
        children: [
          // 0. 로고 및 이름
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SvgPicture.asset(
                  "asset/imgs/icons/star_3_topHome.svg",
                  width: 30.0 * aspectWidth,
                ),
                Text(
                  "personal\nEom\nAdmin",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "sabreshark",
                    fontSize: 32.0 * aspectWidth,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // 1. 우측 상단 스티커
          Positioned(
            top: 18,
            right: 16,
            child: Image.asset(
              "asset/imgs/home_7_gradient_smile.png",
              width: 40.0 * aspectWidth,
            ),
          ),
          // 2. 좌측 상단 Planet her
          Positioned(
            top: 80,
            left: 16,
            child: Image.asset(
              "asset/imgs/home_1_planetHerReceipt.png",
              width: 60.0 * aspectWidth,
            ),
          ),
          // 3. 좌측 상단 별
          Positioned(
            top: 180,
            left: 120,
            child: SvgPicture.asset(
              "asset/imgs/icons/star_2_greenFlash.svg",
              width: 90.0 * aspectWidth,
            ),
          ),
          // 4. 좌측상단 penny board
          Positioned(
            top: 177,
            left: -20,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: RotationTransition(
                turns: const AlwaysStoppedAnimation(15 / 360),
                child: Image.asset(
                  "asset/imgs/home_3_penny_board.png",
                  width: 180.0 * aspectWidth,
                ),
              ),
            ),
          ),
          // 5. 좌측상단 lego
          Positioned(
            top: 120,
            left: 50,
            child: Image.asset(
              "asset/imgs/home_5_lego.png",
              height: 74.0 * aspectWidth,
            ),
          ),
          // 6. 우측상단 eating marshmello
          Positioned(
            top: 25,
            right: 0,
            child: Image.asset(
              "asset/imgs/home_2_eating_marshmello.png",
              width: 250.0 * aspectWidth,
            ),
          ),
          // 7. 중단 사진들
          ...middleImageList.map(
            (e) => Positioned(
              top: MediaQuery.of(context).size.height / 2 - 130,
              right: (e * 40) - 45,
              child: RotationTransition(
                turns: const AlwaysStoppedAnimation(23 / 360),
                child: Image.asset(
                  "asset/imgs/home_6_black_eye.png",
                  width: 100.0 * aspectWidth,
                ),
              ),
            ),
          ),
          // 8. 하단 좌측 웃는 스티커 합성
          Positioned(
            bottom: 100,
            left: 0,
            child: Image.asset(
              "asset/imgs/home_8_smile_sitdown.png",
              width: 177.0 * aspectWidth,
            ),
          ),
          // 9. 하단 주간 star 스티커
          Positioned(
            bottom: 290,
            left: 110,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(25 / 360),
              child: SvgPicture.asset(
                "asset/imgs/icons/star_1.svg",
                width: 75 * aspectWidth,
              ),
            ),
          ),
          // 10. 우측하단 스티커
          Positioned(
              bottom: 250 * aspectWidth,
              right: 0,
              child: Column(
                children: [
                  Image.asset(
                    "asset/imgs/home_9_salute_emoji.png",
                    width: 27 * aspectWidth,
                  ),
                  Image.asset(
                    "asset/imgs/home_9_salute_emoji.png",
                    width: 27 * aspectWidth,
                  ),
                  Image.asset(
                    "asset/imgs/home_9_salute_emoji.png",
                    width: 27 * aspectWidth,
                  ),
                ],
              )),
          // 11. 우측하단 Penny board
          Positioned(
            bottom: 150,
            right: -40,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation((348 / 360)),
              child: Image.asset(
                "asset/imgs/home_3_penny_board.png",
                width: 200.0 * aspectWidth,
              ),
            ),
          ),
          // 12. 우측중앙 보드 타고 있는 모습
          Positioned(
            bottom: 135,
            right: 50,
            child: Image.asset(
              "asset/imgs/home_4_riding_board.png",
              width: 194.0 * aspectWidth,
            ),
          ),
          Positioned(
            bottom: 0,
            child: _menuBar(
              context: context,
              onDiaryTap: () {
                context.pushNamed(DiaryScreen.routeName);
              },
              onPlayListTap: () {
                context.pushNamed(MusicScreen.routeName);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuBar({
    required BuildContext context,
    required VoidCallback onDiaryTap,
    required VoidCallback onPlayListTap,
  }) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFD9D9D9), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          width: deviceWidth,
          height: deviceHeight / 3 + 20,
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 20,
          ),
          child: SizedBox(
            width: deviceWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RoutingButton(
                  onDiaryTap: onDiaryTap,
                  icon: SvgPicture.asset(
                    "asset/imgs/icons/diary.svg",
                    width: 38.0,
                  ),
                  routeName: 'diary',
                ),
                RoutingButton(
                  onDiaryTap: onPlayListTap,
                  icon: SvgPicture.asset(
                    "asset/imgs/icons/playlist.svg",
                    width: 50.0,
                  ),
                  routeName: 'Play\nList',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
