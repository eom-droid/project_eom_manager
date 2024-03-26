import 'package:go_router/go_router.dart';
import 'package:manager/chat/model/chat_model.dart';
import 'package:manager/chat/model/chat_room_model.dart';
import 'package:manager/chat/provider/chat_provider.dart';
import 'package:manager/chat/provider/chat_room_provider.dart';
import 'package:manager/chat/view/chat_detail_screen.dart';
import 'package:manager/common/components/cursor_pagination_error_comp.dart';
import 'package:manager/common/components/cursor_pagination_loading_comp.dart';
import 'package:manager/common/components/custom_circle_avatar.dart';
import 'package:manager/common/const/colors.dart';
import 'package:manager/common/layout/default_layout.dart';
import 'package:manager/common/model/cursor_pagination_model.dart';
import 'package:manager/common/utils/data_utils.dart';
import 'package:manager/user/model/user_model.dart';
import 'package:manager/user/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerWidget {
  static String get routeName => 'chat';

  const ChatScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomState = ref.watch(chatRoomProvider);
    final me = ref.read(userProvider);

    return DefaultLayout(
      backgroundColor: BACKGROUND_BLACK,
      appBar: AppBar(
        title: const Text(
          "Direct Message",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'sabreshark',
            fontSize: 20.0,
          ),
        ),
        backgroundColor: BACKGROUND_BLACK,
      ),
      child: loadBody(
        state: roomState,
        ref: ref,
        buildContext: context,
        me: me as UserModel,
      ),
    );
  }

  Widget loadBody({
    required CursorPaginationBase state,
    required WidgetRef ref,
    required BuildContext buildContext,
    required UserModel me,
  }) {
    // 초기 로딩
    if (state is CursorPaginationLoading) {
      return const CursorPaginationLoadingComp();
    }

    // 에러 발생 시
    if (state is CursorPaginationError) {
      return CursorPaginationErrorComp(
        state: state,
        onRetry: () {
          ref.read(chatRoomProvider.notifier).reconnect();
        },
      );
    }

    final cp = state as CursorPagination<ChatRoomModel>;

    if (cp.data.isEmpty) {
      return const Center(
        child: Text('채팅방이 없습니다.'),
      );
    }
    return _body(
      rooms: cp.data,
      parentBuildContext: buildContext,
      ref: ref,
      me: me,
    );
  }

  _body({
    required List<ChatRoomModel> rooms,
    required BuildContext parentBuildContext,
    required WidgetRef ref,
    required UserModel me,
  }) {
    return ListView.builder(
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];

        final otherUser =
            room.members.firstWhere((element) => element.id != me.id);
        final phoneWidth = MediaQuery.of(parentBuildContext).size.width;
        return GestureDetector(
          onTap: () {
            // enterRoom
            Future.delayed(const Duration(milliseconds: 200), () {
              ref.read(chatProvider(room.id).notifier).enterRoom();
            });

            // routing
            parentBuildContext.pushNamed(
              ChatDetailScreen.routeName,
              pathParameters: {
                'rid': room.id.toString(),
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: PRIMARY_COLOR,
                    width: 1,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: Row(
                children: [
                  CustomCircleAvatar(
                    url: otherUser.profileImg,
                    size: phoneWidth / 5,
                  ),
                  const SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        otherUser.nickname,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      _ChatPreviewWidget(
                        roomId: room.id,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ChatPreviewWidget extends ConsumerWidget {
  final String roomId;
  const _ChatPreviewWidget({
    required this.roomId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProvider(roomId)).currentState;

    return body(
      lastChat: chatState is CursorPagination
          ? chatState.data.isNotEmpty
              ? chatState.data[0]
              : null
          : null,
    );
  }

  body({
    ChatModel? lastChat,
  }) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lastChat != null ? lastChat.content : '첫 메시지를 남겨봐요!',
            style: const TextStyle(
              color: INPUT_BG_COLOR,
              fontSize: 14.0,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6.0),
          Text(
            lastChat != null
                ? DataUtils.timeAgoSinceDate2(lastChat.createdAt)
                : '',
            style: const TextStyle(
              color: BODY_TEXT_COLOR,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
