import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api_servies/repository/auth_repo.dart';
import '../../api_servies/webSocketServices.dart';
import '../../model/chat/session_chat_model.dart'; // your model file
import '../../model/chat/suggesions_Model.dart';

class ChatController extends GetxController {
  final WebSocketService wsService;
  final String sessionId;
  final int personaId;
  var isTyping = false.obs;
  var messages = <Messages>[].obs;
  var session = Rxn<Session>();
  StreamSubscription? _streamSubscription;
  final suggestions = <String>[].obs;
  var isLoadingSuggestions = false.obs;
  var showSuggestions = true.obs; // controls suggestion list visibility






  final ScrollController scrollController = ScrollController();

  ChatController({
    required this.wsService,
    required this.sessionId,
    required this.personaId,
  });

  @override
  void onInit() {
    super.onInit();

    print('🔄 Initializing ChatController for persona: $personaId');

    fetchSessionDetails();

    fetchSuggestions(personaId);

    _streamSubscription = wsService.stream.listen((event) {
      try {
        final data = jsonDecode(event);

        if (data['type'] == 'typing') {
          isTyping.value = (data['is_typing'] == true);
        } else if (data['type'] == 'chat_message' || data['type'] == 'message') {
          isTyping.value = false;
          messages.add(
            Messages(
              id: null,
              content: data['message'] ?? data['content'] ?? '',
              isUser: false,
              createdAt: DateTime.now().toIso8601String(),
            ),
          );
          scrollToBottom();
        }
      } catch (e) {
        print("❌ Error parsing websocket event: $e");
      }
    });
  }






  Future<void> fetchSessionDetails() async {
    try {
      final response = await AuthRepository().fetchSessionsDetails(sessionId);
      final model = SessonChatHistoryModel.fromJson(response);

      session.value = model.session;
      messages.assignAll(model.messages ?? []);
      scrollToBottom();
    } catch (e) {
      print("❌ Failed to fetch session details: $e");
    }
  }

  Future<void> fetchSuggestions(int personaId) async {
    try {
      isLoadingSuggestions.value = true;
      final response = await AuthRepository().AiSuggestions(personaId);

      if (response != null) {
        final model = SuggesionsModel.fromJson(response);

        if (model.success) {
          suggestions.assignAll(model.suggestions);
          showSuggestions.value = suggestions.isNotEmpty;
          print('✅ Suggestions loaded: ${model.suggestions.length}');
        } else {
          print("❌ Suggestions model.success == false");
          suggestions.clear();
          showSuggestions.value = false;
        }
      } else {
        print("❌ Suggestions API returned null");
        suggestions.clear();
        showSuggestions.value = false;
      }
    } catch (e) {
      print('❌ Failed to fetch suggestions: $e');
      suggestions.clear();
      showSuggestions.value = false;
    } finally {
      isLoadingSuggestions.value = false;
    }
  }

  void onSuggestionTap(String suggestion, TextEditingController textController) {
    textController.text = suggestion;
    showSuggestions.value = false;
  }

  void send(String msg) {
    showSuggestions.value = false;

    messages.add(
      Messages(
        id: null,
        content: msg,
        isUser: true,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    wsService.sendMessage(msg);
    scrollToBottom();
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
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
