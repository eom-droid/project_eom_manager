import 'dart:async';

import 'package:manager/chat/model/chat_response_model.dart';
import 'package:manager/common/socketio/socketio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRoomRepositoryProvider = Provider<ChatRoomRepository>((ref) {
  final socketIO = ref.read(socketIOProvider);

  return ChatRoomRepository(
    socket: socketIO,
  );
});

class ChatRoomRepository {
  final SocketIO socket;
  final chatRoomResponse = StreamController<ChatResponseModel>();
  ChatRoomRepository({
    required this.socket,
  }) : super() {
    init();
  }

  init() {
    onGetChatRoomsRes();
  }

  void onGetChatRoomsRes() async {
    socket.on('getChatRoomsRes', (data) {
      print("[SocketIO] getChatRoomRes");
      chatRoomResponse.sink.add(
        ChatResponseModel(
          state: ChatResponseState.getChatRoomsRes,
          data: data,
        ),
      );
    });
  }
}
