import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api_servies/api_Constant.dart';
import '../../api_servies/neteork_api_services.dart';
import '../../api_servies/webSocketServices.dart';
import '../../model/chat/persona_chat.dart';

class ChatController extends GetxController {
  final WebSocketService wsService;
  final String sessionId;

  var messages = <Message>[].obs;
  var session = Rxn<Session>();
  StreamSubscription? _streamSubscription;

  final ScrollController scrollController = ScrollController();

  ChatController({
    required this.wsService,
    required this.sessionId,
  });

  @override
  void onInit() {
    fetchChatHistory();
    _streamSubscription = wsService.stream.listen((event) {
      final data = jsonDecode(event);

      if (data['type'] == 'chat_message') {
        messages.add(Message(sender: 'ai', message: data['message'], timestamp: DateTime.now()));
        scrollToBottom();
      } else if (data['type'] == 'message') {
        messages.add(Message(sender: 'ai', message: data['content'], timestamp: DateTime.now()));
        scrollToBottom();
      }
    });
    super.onInit();
  }


  void fetchChatHistory() async {
    final url = "${ApiConstants.baseUrl}/api/chat/sessions/$sessionId/";
    final response = await NetworkApiServices.getApi(url, tokenType: 'login');

    final model = PersonaChatModel.fromJson(response);
    session.value = model.data.session;
    messages.addAll(model.data.messages);
    scrollToBottom();
  }

  void send(String msg) {
    messages.add(Message(sender: 'me', message: msg, timestamp: DateTime.now()));
    wsService.sendMessage(msg);
    scrollToBottom();
  }


  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    _streamSubscription?.cancel();
    wsService.disconnect();
    super.onClose();
  }
}
