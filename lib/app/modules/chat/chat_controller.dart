import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api_servies/repository/auth_repo.dart';
import '../../api_servies/webSocketServices.dart';
import '../../model/chat/session_chat_model.dart';
import '../../model/chat/suggesions_Model.dart';

class ChatController extends GetxController {
  final WebSocketService wsService;
  final String sessionId;
  final int personaId;
  var isTyping = false.obs;

  var messages = <Message>[].obs;
  var session = Rxn<Session>();

  StreamSubscription? _streamSubscription;

  final suggestions = <String>[].obs;
  var isLoadingSuggestions = false.obs;

  final ScrollController scrollController = ScrollController();

  ChatController({
    required this.wsService,
    required this.sessionId,
    required this.personaId,
  });

  @override
  void onInit() {
    print('🔄 Initializing ChatController for persona: $personaId');

    fetchSessionDetails();
    fetchSuggestions(personaId).then((_) {
      // After fetching suggestions, add them as AI messages
      if (suggestions.isNotEmpty) {
        for (var suggestion in suggestions) {
          messages.add(Message(
            sender: 'ai',
            message: suggestion,
            timestamp: DateTime.now(),
            isSuggestion: true, // Add this flag
          ));
        }
        scrollToBottom();
      }
    });

    _streamSubscription = wsService.stream.listen((event) {
      final data = jsonDecode(event);

      if (data['type'] == 'typing') {
        isTyping.value = data['is_typing'] == true; // or however your backend sends it
      } else if (data['type'] == 'chat_message') {
        isTyping.value = false;
        messages.add(Message(
          sender: 'ai',
          message: data['message'],
          timestamp: DateTime.now(),
          isSuggestion: false,
        ));
        scrollToBottom();
      } else if (data['type'] == 'message') {
        isTyping.value = false;
        messages.add(Message(
          sender: 'ai',
          message: data['content'],
          timestamp: DateTime.now(),
          isSuggestion: false,
        ));
        scrollToBottom();
      }
    });


    super.onInit();
  }




  Future<void> fetchSuggestions(int personaId) async {
    try {
      isLoadingSuggestions.value = true;
      final response = await AuthRepository().AiSuggestions(personaId);
      print('🔍 Suggestions API Response: $response'); // Debug print

      if (response != null) {
        final model = SuggesionsModel.fromJson(response);
        if (model.success) {
          suggestions.assignAll(model.suggestions);
          print('✅ Loaded suggestions: ${suggestions.length}'); // Debug print
        }
      }
    } catch (e) {
      print('❌ Failed to fetch suggestions: $e');
      suggestions.clear();
    } finally {
      isLoadingSuggestions.value = false;
    }
  }


  Future<void> fetchSessionDetails() async {
    try {
      final response = await AuthRepository().fetchSessionsDetails(int.parse(sessionId));
      final model = SessionChatModel.fromJson(response);

      session.value = model.session;
      messages.assignAll(model.messages);
      scrollToBottom();
    } catch (e) {
      print("❌ Failed to fetch session details: $e");
    }
  }

  void send(String msg) {
    messages.add(Message(sender: 'me', message: msg, timestamp: DateTime.now()));
    wsService.sendMessage(msg);
    scrollToBottom();
  }


  Future<void> refreshSuggestions() async {
    await fetchSuggestions(personaId);
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
