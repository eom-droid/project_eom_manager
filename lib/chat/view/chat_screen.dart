import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/chat/model/chat_message_model.dart';
import 'package:manager/chat/model/chat_model.dart';
import 'package:manager/chat/provider/chat_provider.dart';
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

class ChatScreen extends ConsumerStatefulWidget {
  static String get routeName => 'chat';

  const ChatScreen({
    super.key,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // ref.read(chatProvider.notifier).reconnect();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(chatProvider.notifier).reJoinRoom(
            roomId: "",
            route: ChatScreen.routeName,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
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
        state: chatState,
        buildContext: context,
        me: me as UserModel,
      ),
    );
  }

  Widget loadBody({
    required CursorPaginationBase state,
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
          ref.read(chatProvider.notifier).reconnect();
        },
      );
    }

    final cp = state as CursorPagination<ChatModel>;

    if (cp.data.isEmpty) {
      return const Center(
        child: Text('채팅방이 없습니다.'),
      );
    }
    return _body(
      rooms: cp.data,
      parentBuildContext: buildContext,
      me: me,
    );
  }

  _body({
    required List<ChatModel> rooms,
    required BuildContext parentBuildContext,
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
            // routing
            parentBuildContext.pushNamed(
              ChatDetailScreen.routeName,
              pathParameters: {
                'rid': room.id,
              },
            );
          },
          child: Stack(
            children: [
              Padding(
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
                            chat: room,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              _NewChatNotifier(
                chat: room,
                myId: me.id,
              )
            ],
          ),
        );
      },
    );
  }
}

class _NewChatNotifier extends StatelessWidget {
  final String myId;
  final ChatModel chat;

  const _NewChatNotifier({
    required this.myId,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    ChatMessageModel? lastMessage;
    final me = chat.members.firstWhereOrNull((element) => element.id == myId);

    if (chat is ChatDetailModel) {
      final pChat = chat as ChatDetailModel;
      if (pChat.messages.isEmpty) {
        lastMessage = null;
      } else {
        lastMessage = pChat.messages
            .where((element) =>
                element is! ChatMessageFailedModel ||
                element is! ChatMessageTempModel)
            .firstOrNull;
      }
    } else {
      lastMessage = chat.lastMessage;
    }

    if (me != null &&
        lastMessage != null &&
        lastMessage.id != me.lastReadChatId) {
      return Positioned(
        top: 7,
        right: 5,
        child: Container(
          padding: const EdgeInsets.only(
            top: 4,
            bottom: 8,
            left: 8,
            right: 8,
          ),
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(
              Radius.circular(14.0),
            ),
          ),
          constraints: const BoxConstraints(
            minWidth: 14,
            minHeight: 14,
          ),
          child: const Text(
            'New',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}

class _ChatPreviewWidget extends StatelessWidget {
  final ChatModel chat;
  const _ChatPreviewWidget({
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    ChatMessageModel? lastChat;
    if (chat is ChatDetailModel) {
      final pChat = chat as ChatDetailModel;
      if (pChat.messages.isEmpty) {
        lastChat = null;
      } else {
        lastChat = pChat.messages
            .where((element) =>
                element is! ChatMessageFailedModel ||
                element is! ChatMessageTempModel)
            .firstOrNull;
      }
    } else {
      lastChat = chat.lastMessage;
    }
    return Column(
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
    );
  }
}
