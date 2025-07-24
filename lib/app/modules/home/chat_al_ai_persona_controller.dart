import 'package:get/get.dart';
import '../../api_servies/token.dart';
import '../../api_servies/webSocketServices.dart';
import '../../api_servies/repository/auth_repo.dart';
import '../../model/home/chat_al_ai_persona.dart';
import '../chat/caht_view.dart';
import '../chat/chat_controller.dart';

class ChatAllAiPersona extends GetxController {
  var personaList = <Data>[].obs;
  final isLoading = true.obs;

  final authRepo = AuthRepository();

  /// Cache: personaId -> sessionId
  final Map<int, String> _sessionMap = {};

  @override
  void onInit() {
    fetchAllAiPersona();
    super.onInit();
  }

  Future<void> startChatSession(Data persona) async {
    try {
      final personaId = persona.id!;
      final tag = 'chat_$personaId';
      print('👉 Starting chat for persona: $personaId');

      final token = await TokenStorage.getLoginAccessToken();
      if (token == null) throw Exception('Token is null');

      // Step 1: Get existing sessionId if stored
      String? sessionIdNullable = await TokenStorage.getPersonaSessionId(personaId);
      late String sessionId;

      if (sessionIdNullable == null) {
        // Step 2: Create new session via API
        sessionId = await authRepo.createSession(personaId) ?? (throw Exception('Failed to create session'));


        print("🆕 ♻️♻️♻️♻️♻️♻️♻️NEW sessionId type: ${sessionId.runtimeType}, value: '$sessionId'");

        // Step 3: Save to SharedPreferences
        await TokenStorage.savePersonaSessionId(personaId, sessionId);
      } else {
        // Step 4: Use existing sessionId
        sessionId = sessionIdNullable;
        print("♻️ Reusing stored sessionId for persona $personaId: $sessionId");

        print("♻️♻️♻️♻️♻️♻️️️STORED sessionId type: ${sessionId.runtimeType}, value: '$sessionId'");
      }

      // Step 5: Initialize WebSocket
      final wsService = WebSocketService();
      wsService.connect(sessionId, token, personaId: personaId);

      // Step 6: Register ChatController with unique tag if not already
      if (!Get.isRegistered<ChatController>(tag: tag)) {
        Get.put(ChatController(
          wsService: wsService,
          sessionId: sessionId,
          personaId: personaId,
        ), tag: tag);
      }

      // Step 7: Navigate to chat view
      Get.to(() => ChatView(
        sessionId: sessionId,
        token: token,
        webSocketService: wsService,
        controllerTag: tag,
      ));

    } catch (e) {
      print('❌ Error in startChatSession: $e');
      Get.snackbar("Error", "Could not start chat session");
    }
  }

  // Future<void> startChatSession(Data persona) async {
  //   try {
  //     final personaId = persona.id!;
  //     final tag = 'chat_$personaId'; // unique tag for each persona
  //
  //     print('👉 Start chat for persona: $personaId');
  //
  //     String? sessionId = _sessionMap[personaId];
  //     final token = await TokenStorage.getLoginAccessToken();
  //     if (token == null) throw Exception('Token is null');
  //
  //     if (sessionId != null) {
  //       print("♻️ Reusing existing sessionId for persona $personaId: $sessionId");
  //
  //       WebSocketService? wsService;
  //
  //       if (!Get.isRegistered<ChatController>(tag: tag)) {
  //         wsService = WebSocketService();
  //         wsService.connect(sessionId, token, personaId: personaId);
  //
  //         Get.put(ChatController(
  //           wsService: wsService,
  //           sessionId: sessionId,
  //           personaId: personaId,
  //         ), tag: tag);
  //       } else {
  //         wsService = Get.find<ChatController>(tag: tag).wsService;
  //       }
  //
  //       // ✅ Go to chat with this controller tag
  //       Get.to(() => ChatView(
  //         sessionId: sessionId!,
  //         token: token,
  //         webSocketService: wsService!,
  //         controllerTag: tag,
  //       ));
  //       return;
  //     }
  //
  //     // ✅ Create new session if not found
  //     sessionId = await authRepo.createSession(personaId);
  //     if (sessionId == null) throw Exception('Session ID is null');
  //     _sessionMap[personaId] = sessionId;
  //
  //     final wsService = WebSocketService();
  //     wsService.connect(sessionId, token, personaId: personaId);
  //
  //     // Always put new controller for this persona with tag
  //     Get.put(ChatController(
  //       wsService: wsService,
  //       sessionId: sessionId,
  //       personaId: personaId, // Add this
  //     ), tag: tag);
  //
  //     Get.to(() => ChatView(
  //       sessionId: sessionId!,
  //       token: token,
  //       webSocketService: wsService,
  //       controllerTag: tag,
  //     ));
  //
  //   } catch (e) {
  //     print('❌ Error in startChatSession: $e');
  //     Get.snackbar("Error", "Could not start chat session");
  //   }
  // }




  Future<void> fetchAllAiPersona() async {
    try {
      isLoading.value = true;
      final response = await authRepo.getAllAiPersona();
      final model = AllAiPersonaChat.fromJson(response);
      personaList.value = model.data ?? [];
    } catch (e) {
      print("❌ Error fetching personas: $e");
    } finally {
      isLoading.value = false;
    }
  }




}



