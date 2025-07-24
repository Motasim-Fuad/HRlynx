import 'package:cached_network_image/cached_network_image.dart';
import 'package:damaged303/app/modules/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../api_servies/api_Constant.dart';
import '../../api_servies/repository/auth_repo.dart';
import '../../api_servies/token.dart';
import '../../common_widgets/customtooltip.dart';
import '../../model/chat/session_chat_model.dart';
import '../../utils/app_colors.dart';
import 'chat_controller.dart';
import '../../api_servies/webSocketServices.dart';

// Helper to parse ISO datetime safely
DateTime? parseIsoDate(String? isoString) {
  if (isoString == null) return null;
  try {
    return DateTime.parse(isoString);
  } catch (e) {
    return null;
  }
}

class ChatView extends StatelessWidget {
  final String sessionId;
  final String token;
  final WebSocketService webSocketService;
  final String controllerTag;

  ChatView({
    super.key,
    required this.sessionId,
    required this.token,
    required this.webSocketService,
    required this.controllerTag,
  });

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {

// Add safety check for controller existence
    if (!Get.isRegistered<ChatController>(tag: controllerTag)) {
      print('Initializing new ChatController with tag: $controllerTag');
      Get.put(
        ChatController(
          wsService: webSocketService,
          sessionId: sessionId,
          personaId: webSocketService.personaId ?? 0, // Add personaId to WebSocketService
        ),
        tag: controllerTag,
        permanent: true,
      );
    }



    final chatController = Get.find<ChatController>(tag: controllerTag);
    final tooltipCtrl = Get.put(ChatTooltipController());

    return Obx(() {
      final session = chatController.session.value;

      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(onPressed: (){
            Get.off(HomeView());
          }, icon: Icon(Icons.arrow_back)),
          title: session != null
              ? Row(
            children: [
              CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.08,
                backgroundImage: CachedNetworkImageProvider(
                  "${ApiConstants.baseUrl}${session.persona?.avatar ?? ''}",
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      session.persona?.name ?? '',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      session.persona?.title ?? '',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        color: Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          )
              : const Text('Loading...'),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.more_vert_outlined),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // AI Guidance text + tooltip
            Stack(
              children: [
                GestureDetector(
                  onTap: tooltipCtrl.toggle,
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "AI Guidance Only — Not Legal or HR Advice. Consult professionals for critical decisions.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                        color: Colors.blueGrey[700],
                      ),
                    ),
                  ),
                ),
                if (tooltipCtrl.isVisible.value)
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: tooltipCtrl.hide,
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                          Align(
                            alignment: Alignment.center,
                            child: ChatTooltipBubble(
                              message:
                              "AI-powered responses are provided for informational purposes only and do not constitute legal, compliance, or professional advice. Users should consult qualified HR, legal, or compliance professionals before making employment decisions. HRlynx AI Personas are not a substitute for independent judgment or expert consultation. Content may not reflect the most current regulatory or legal developments. Use of this platform is subject to the Terms of Use and Privacy Policy.",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Loading suggestions indicator
            if (chatController.isLoadingSuggestions.value)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              ),

            // Messages list (Expanded to fill remaining space)
            Expanded(
              child: Obx(() => ListView.builder(
                controller: chatController.scrollController,
                itemCount: chatController.messages.length,
                itemBuilder: (_, i) {
                  final message = chatController.messages[i];
                  final isMe = message.isUser == true;

                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    alignment:
                    isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isMe)
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: session != null &&
                                session.persona?.avatar != null
                                ? CachedNetworkImageProvider(
                                "${ApiConstants.baseUrl}${session.persona!.avatar}")
                                : null,
                          ),
                        if (!isMe) const SizedBox(width: 8),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue[100] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  message.content ?? '',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatTime(parseIsoDate(message.createdAt)),
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )),
            ),

            Obx(() {
              if (chatController.isTyping.value) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: session != null &&
                            session.persona?.avatar != null
                            ? CachedNetworkImageProvider(
                            "${ApiConstants.baseUrl}${session.persona!.avatar}")
                            : null,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Typing...",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),

            Obx(() {
              if (chatController.showSuggestions.value &&
                  chatController.suggestions.isNotEmpty) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align to left
                      children: chatController.suggestions.map((suggestion) {
                        return GestureDetector(
                          onTap: () {
                            textController.text = suggestion;
                            chatController.showSuggestions.value = false;
                            textController.selection = TextSelection.fromPosition(
                              TextPosition(offset: textController.text.length),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              suggestion,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),

            const Divider(height: 1),

            // Input field + send button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      ),
                      onTap: () {
                        // Show suggestions again when input is tapped if any
                        if (chatController.suggestions.isNotEmpty) {
                          chatController.showSuggestions.value = true;
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(onPressed: (){

                  }, icon: Icon(Icons.mic)),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final text = textController.text.trim();
                      if (text.isNotEmpty) {
                        chatController.send(text);
                        textController.clear();
                        chatController.showSuggestions.value = false; // hide suggestions after send
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        endDrawer: Drawer(
          width: Get.width * 0.7,
          child: Container(
            color: AppColors.primarycolor,
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // ✅ FIXED: Single "New chat" button with proper implementation
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: GestureDetector(
                      onTap: () async {
                        await _createNewChatSession();
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.edit_note_rounded, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'New chat',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: GestureDetector(
                      onTap: () {
                        Get.back(); // Close drawer
                        // Get.to(ChatHistory()); // Navigate to history if needed
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.access_time_outlined, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'History',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // ✅ FIXED: Extracted new chat creation logic into separate method
// Replace your _createNewChatSession method with this corrected version:
// Replace your _createNewChatSession method with this corrected version:

  Future<void> _createNewChatSession() async {
    final chatController = Get.find<ChatController>(tag: controllerTag);
    final currentPersonaId = chatController.personaId;

    try {
      // Close drawer first
      Get.back();

      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Create new session
      final newSessionId = await AuthRepository().createSession(currentPersonaId);

      if (newSessionId != null) {
        // Save the new session ID
        await TokenStorage.savePersonaSessionId(currentPersonaId, newSessionId);

        final token = await TokenStorage.getLoginAccessToken() ?? '';

        // Create new WebSocket service and controller tag
        final newWebSocket = WebSocketService();
        final newControllerTag = 'chat-$newSessionId-${DateTime.now().millisecondsSinceEpoch}';

        // Connect WebSocket
        await newWebSocket.connect(newSessionId, token, personaId: currentPersonaId);

        // Create new controller
        final newController = ChatController(
          wsService: newWebSocket,
          sessionId: newSessionId,
          personaId: currentPersonaId,
        );

        // Put the new controller in GetX
        Get.put(newController, tag: newControllerTag, permanent: true);

        // Close loading dialog
        Get.back();

        // Navigate to new chat view
        Get.offAll(() => ChatView(
          sessionId: newSessionId,
          token: token,
          webSocketService: newWebSocket,
          controllerTag: newControllerTag,
        ));

        // Delay cleanup of old controller
        Future.delayed(const Duration(seconds: 1), () {
          if (Get.isRegistered<ChatController>(tag: controllerTag)) {
            final oldController = Get.find<ChatController>(tag: controllerTag);
            oldController.onClose();
            Get.delete<ChatController>(tag: controllerTag);
          }
        });
      } else {
        Get.back();
        Get.snackbar("Error", "Failed to create a new chat session.");
      }
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Error creating new session: $e");
      print("Error in _createNewChatSession: $e");
    }
  }

  String formatTime(DateTime? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final isToday =
        now.day == time.day && now.month == time.month && now.year == time.year;

    if (isToday) {
      return DateFormat.jm().format(time); // e.g., 2:45 PM
    } else {
      return DateFormat('dd/MM/yyyy, h:mm a').format(time); // e.g., 22/07/2025, 2:45 PM
    }
  }
}