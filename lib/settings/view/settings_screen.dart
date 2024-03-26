import 'package:manager/common/components/custom_circle_avatar.dart';
import 'package:manager/common/const/colors.dart';
import 'package:manager/common/layout/default_layout.dart';
import 'package:manager/settings/view/profile_modify_screen.dart';

import 'package:manager/user/model/user_model.dart';
import 'package:manager/user/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  static String get routeName => 'settings';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(userProvider);

    return DefaultLayout(
      backgroundColor: BACKGROUND_BLACK,
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'sabreshark',
            fontSize: 20.0,
          ),
        ),
        elevation: 0,
        backgroundColor: BACKGROUND_BLACK,
      ),
      child: me == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),
                _profilePart(
                  me: me as UserModel,
                  context: context,
                ),
                const SizedBox(height: 150),
                InkWell(
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text(
                      "로그아웃",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onTap: () {
                    ref.read(userProvider.notifier).logout();
                  },
                ),
                const SizedBox(height: 100),
              ],
            ),
    );
  }

  _profilePart({
    required UserModel me,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            CustomCircleAvatar(
              url: me.profileImg,
              size: 100,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          me.nickname,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          child: const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Text(
              "프로필 수정",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18.0,
              ),
            ),
          ),
          onTap: () {
            context.pushNamed(
              ProfileModify.routeName,
            );
          },
        ),
      ],
    );
  }
}
