import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/common/view/root_tab.dart';
import 'package:manager/common/view/splash_screen.dart';
import 'package:manager/diary/view/diary_detail_screen.dart';
import 'package:manager/diary/view/diary_edit_screen.dart';
import 'package:manager/music/view/music_edit_screen.dart';

final routerProvider = ChangeNotifierProvider<RouterProvider>((ref) {
  return RouterProvider(ref: ref);
});

class RouterProvider extends ChangeNotifier {
  final Ref ref;

  RouterProvider({required this.ref}) {
    // ref.listen<UserModelBase?>(userMeProiver, (previous, next) {
    //   if (previous != next) {
    //     notifyListeners();
    //   }
    // });
  }

  List<GoRoute> get routes => [
        GoRoute(
          path: '/',
          name: RootTab.routeName,
          builder: (_, __) => const RootTab(),
          routes: [
            GoRoute(
              path: 'diary/:rid',
              name: DiaryDetailScreen.routeName,
              builder: (_, state) => DiaryDetailScreen(
                id: state.pathParameters['rid']!,
              ),
            ),
            GoRoute(
              path: 'diary/:rid/edit',
              name: DiaryEditScreen.routeName,
              builder: (_, state) => DiaryEditScreen(
                id: state.pathParameters['rid']!,
              ),
            ),
            // GoRoute(
            //   path: 'music/:rid',
            //   name: MusciDetailScreen.routeName,
            //   builder: (_, state) {
            //     MusicModel music = state.extra as MusicModel;

            //     return MusciDetailScreen(
            //       id: state.pathParameters['rid']!,
            //       music: music,
            //     );
            //   },
            // ),
            GoRoute(
              path: 'music/:rid/edit',
              name: MusicEditScreen.routeName,
              builder: (_, state) => MusicEditScreen(
                id: state.pathParameters['rid']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, __) => const SplashScreen(),
        ),
        // GoRoute(
        //   path: '/diaryAdd',
        //   name: DiaryAddScreen.routeName,
        //   builder: (_, __) => const DiaryAddScreen(),
        // ),
        // GoRoute(
        //   path: '/login',
        //   name: LoginScreen.routeName,
        //   builder: (_, __) => const LoginScreen(),
        // ),
        // GoRoute(
        //   path: '/basket',
        //   name: BasketScreen.routeName,
        //   builder: (_, __) => const BasketScreen(),
        // ),
        // GoRoute(
        //   path: '/order_done',
        //   name: OrderDoneScreen.routeName,
        //   builder: (_, __) => const OrderDoneScreen(),
        // ),
      ];

  // SplashScreen
  // 앱을 처음 시작했을때
  // 토큰이 존재하는지 확인하고
  // 로그인 스크린으로 보내줄지
  // 홈 스크린으로 보내줄지 확인하는 과정이 필요하다.
  String? redirectLogic(BuildContext _, GoRouterState state) {
    // final UserModelBase? user = ref.read(userMeProiver);

    // final logginIn = state.location == '/login';

    // // 유저 정보가 없는데
    // // 로그인 중이면 그대로 로그인 페이지에 두고
    // // 만약 로그인중이 아니라면 로그인 페이지로 이동
    // if (user == null) {
    //   return logginIn ? null : '/login';
    // }

    // // user가 null이 아님

    // // UserModel
    // // 사용자 정보가 있는 상태면
    // // 로그인 중이거나 현재 위치가 SplashScreen이면
    // // 홈으로 이동
    // if (user is UserModel) {
    //   return logginIn || state.location == '/splash' ? '/' : null;
    // }

    // // UserModelError
    // // 무조건 login페이지로 이동
    // if (user is UserModelError) {
    //   return !logginIn ? '/login' : null;
    // }
    return null;
  }

  // void logout() {
  //   ref.read(userMeProiver.notifier).logout();
  // }
}
