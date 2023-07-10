import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/common/const/data.dart';
import 'dart:math' as math;

import 'package:manager/diary/view/diary_screen.dart';
import 'package:manager/music/view/music_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // double width = _imageKey.currentContext?.size?.width ?? 0;
    // print(width);
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
    upperBound: homeBackgroundImageWidth - MediaQuery.of(context).size.width,
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
          child: Image.asset(
            "asset/imgs/home_background.png",
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.scaleDown,
          ),
        );
      }),
    );
  }
}

class BackgroundFilter extends StatelessWidget {
  const BackgroundFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD9D9D9).withOpacity(0.05),
    );
  }
}

class _FrontImagesRender extends StatelessWidget {
  const _FrontImagesRender();

  @override
  Widget build(BuildContext context) {
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
                  width: 30.0,
                ),
                const Text(
                  "personal\nEom",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "sabreshark",
                    fontSize: 32.0,
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
              width: 40.0,
            ),
          ),
          // 2. 좌측 상단 Planet her
          Positioned(
            top: 80,
            left: 16,
            child: Image.asset(
              "asset/imgs/home_1_planetHerReceipt.png",
              width: 60.0,
            ),
          ),
          // 3. 좌측 상단 별
          Positioned(
            top: 180,
            left: 120,
            child: SvgPicture.asset(
              "asset/imgs/icons/star_2_greenFlash.svg",
              width: 90.0,
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
                  width: 180.0,
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
              height: 74.0,
            ),
          ),
          // 6. 우측상단 eating marshmello
          Positioned(
            top: 25,
            right: 0,
            child: Image.asset(
              "asset/imgs/home_2_eating_marshmello.png",
              width: 250.0,
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
                  width: 100.0,
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
              width: 177.0,
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
                width: 75,
              ),
            ),
          ),
          // 10. 우측하단 스티커
          const Positioned(
            bottom: 250,
            right: 0,
            child: Text(
              "🫡\n🫡\n🫡",
              style: TextStyle(
                fontSize: 30.0,
                height: 1.01,
              ),
            ),
          ),
          // 11. 우측하단 Penny board
          Positioned(
            bottom: 150,
            right: -40,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation((348 / 360)),
              child: Image.asset(
                "asset/imgs/home_3_penny_board.png",
                width: 200.0,
              ),
            ),
          ),
          // 12. 우측중앙 보드 타고 있는 모습
          Positioned(
            bottom: 135,
            right: 50,
            child: Image.asset(
              "asset/imgs/home_4_riding_board.png",
              width: 194.0,
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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3 + 20,
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 20,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: onDiaryTap,
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        width: 75,
                        height: 115,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: Colors.white,
                            width: 3.0,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFFD9D9D9),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "asset/imgs/icons/diary.svg",
                              width: 38.0,
                            ),
                            const Text(
                              'diary',
                              style: TextStyle(
                                fontFamily: "sabreshark",
                                fontSize: 12.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: onPlayListTap,
                  child: ClipRRect(
                    child: Container(
                      width: 75,
                      height: 115,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Colors.white,
                          width: 3.0,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFD9D9D9),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "asset/imgs/icons/playlist.svg",
                            width: 50.0,
                          ),
                          const Text(
                            'Play\nList',
                            style: TextStyle(
                              fontFamily: "sabreshark",
                              fontSize: 12.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
