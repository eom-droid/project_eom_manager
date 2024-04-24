import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/auth/view/login_screen.dart';
import 'package:manager/chat/view/chat_detail_screen.dart';
import 'package:manager/chat/view/chat_screen.dart';

import 'package:manager/common/view/root_tab.dart';
import 'package:manager/common/view/splash_screen.dart';
import 'package:manager/diary/view/diary_detail_screen.dart';
import 'package:manager/diary/view/diary_edit_screen.dart';
import 'package:manager/diary/view/diary_screen.dart';
import 'package:manager/music/view/music_edit_screen.dart';
import 'package:manager/music/view/music_screen.dart';
import 'package:manager/settings/view/profile_modify_screen.dart';
import 'package:manager/settings/view/settings_screen.dart';
import 'package:manager/user/model/user_model.dart';

import 'package:manager/user/provider/user_provider.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  // watch - 값이 변경되면 다시 빌드
  // read - 값이 변경되어도 다시 빌드하지 않음
  final provider = ref.read(routerProvider);

  return GoRouter(
    routes: provider.routes,
    initialLocation: '/splash',
    refreshListenable: provider,
    redirect: provider.redirectLogic,
  );
});

final routerProvider = ChangeNotifierProvider<RouterProvider>((ref) {
  return RouterProvider(ref: ref);
});

class RouterProvider extends ChangeNotifier {
  final Ref ref;

  RouterProvider({required this.ref}) {
    ref.listen<UserModelBase?>(userProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
        GoRoute(
          path: '/',
          name: RootTab.routeName,
          builder: (_, __) => const RootTab(),
          routes: [
            GoRoute(
              path: 'diary',
              name: DiaryScreen.routeName,
              builder: (_, state) => DiaryScreen(),
            ),
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
            GoRoute(
              path: 'music',
              name: MusicScreen.routeName,
              builder: (_, state) => const MusicScreen(),
            ),
            GoRoute(
              path: 'music/:rid/edit',
              name: MusicEditScreen.routeName,
              builder: (_, state) => MusicEditScreen(
                id: state.pathParameters['rid']!,
              ),
            ),
            GoRoute(
              path: 'chat',
              name: ChatScreen.routeName,
              builder: (_, __) => const ChatScreen(),
            ),
            GoRoute(
              path: 'chat/:rid',
              name: ChatDetailScreen.routeName,
              builder: (_, state) => ChatDetailScreen(
                id: state.pathParameters['rid']!,
              ),
            ),
            GoRoute(
                path: 'login',
                name: LoginScreen.routerName,
                builder: (_, state) => const LoginScreen()),
            GoRoute(
              path: "settings",
              name: SettingsScreen.routeName,
              builder: (_, __) => const SettingsScreen(),
              routes: [
                GoRoute(
                  path: "profileModify",
                  name: ProfileModify.routeName,
                  builder: (_, __) => ProfileModify(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, __) => const SplashScreen(),
        ),
      ];

  // SplashScreen
  // 앱을 처음 시작했을때
  // 토큰이 존재하는지 확인하고
  // 로그인 스크린으로 보내줄지
  // 홈 스크린으로 보내줄지 확인하는 과정이 필요하다.

  String? redirectLogic(BuildContext _, GoRouterState state) {
    final UserModelBase? user = ref.read(userProvider);

    final loginRoute = state.location == '/login';
    final splashRoute = state.location == '/splash';

    // 유저 정보가 없는데
    // 로그인 중이면 그대로 로그인 페이지에 두고
    // 만약 로그인중이 아니라면 로그인 페이지로 이동

    // UserModelError
    // 무조건 login페이지로 이동
    if (user == null || user is UserModelError) {
      return loginRoute ? null : '/login';
    }

    // user가 null이 아님

    // UserModel
    // 사용자 정보가 있는 상태면
    // 로그인 중이거나 현재 위치가 SplashScreen이면
    // 홈으로 이동
    if (user is UserModel) {
      return loginRoute || splashRoute ? '/' : null;
    }

    return null;
  }
}
