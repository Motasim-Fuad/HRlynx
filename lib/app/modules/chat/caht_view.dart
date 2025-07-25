import 'package:cached_network_image/cached_network_image.dart';
import 'package:damaged303/app/modules/chat/widget/sessionTitle.dart';
import 'package:damaged303/app/modules/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../api_servies/api_Constant.dart';
import '../../api_servies/repository/auth_repo.dart';
import '../../api_servies/token.dart';
import '../../common_widgets/customtooltip.dart';
import '../../model/chat/sessionHistoryModel.dart';
import '../../utils/app_colors.dart';
import '../main_screen/main_screen_view.dart';
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

// Separate widget for refresh button to avoid Obx issues
class RefreshButton extends StatelessWidget {
  final ChatController chatController;

  const RefreshButton({super.key, required this.chatController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return IconButton(
        icon: chatController.isReloadingHistory.value
            ? RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: chatController.historyAnimationController,
              curve: Curves.linear,
            ),
          ),
          child: const Icon(Icons.refresh, color: Colors.white),
        )
            : const Icon(Icons.refresh, color: Colors.white),
        onPressed: () async {
          if (!chatController.isReloadingHistory.value) {
            // Start animation
            chatController.isReloadingHistory.value = true;
            chatController.historyAnimationController.repeat();

            // Make API call
            await chatController.reloadHistory();

            // Stop animation
            chatController.historyAnimationController.stop();
            chatController.isReloadingHistory.value = false;
          }
        },
      );
    });
  }
}

// Separate widget for history list to avoid Obx issues
class HistoryListWidget extends StatelessWidget {
  final ChatController chatController;
  final String sessionId;
  final Function(String) onLoadSession;
  final Function(int) onDeleteHistory;

  const HistoryListWidget({
    super.key,
    required this.chatController,
    required this.sessionId,
    required this.onLoadSession,
    required this.onDeleteHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // This Obx watches for the reload trigger
      chatController.isReloadingHistory.value; // This line ensures Obx watches this observable

      return FutureBuilder(
        future: AuthRepository().fetchPersonaChatHistory(chatController.personaId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!['success']) {
            return Center(child: Text("Failed to load history", style: TextStyle(color: Colors.white)));
          }

          final data = snapshot.data!;
          final sessions = (data['sessions'] as List).map((e) => SessionHistory.fromJson(e)).toList();

          if (sessions.isEmpty) {
            return Center(child: Text("No chat history", style: TextStyle(color: Colors.white)));
          }

          return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              // Add bounds checking
              if (index >= sessions.length) {
                return const SizedBox.shrink();
              }

              final session = sessions[index];
              final isCurrentSession = session.id == sessionId;

              return SessionHistoryTile(
                session: session,
                onTap: () => onLoadSession(session.id),
                onDelete: isCurrentSession ? null : () async {
                  await onDeleteHistory(int.parse(session.id));
                  // Trigger rebuild by updating the observable
                  chatController.reloadHistory();
                },
                isCurrentSession: isCurrentSession,
              );
            },
          );
        },
      );
    });
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
            Get.off(MainScreen());
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

            // In your ChatView's build method, modify the Obx widget for suggestions:
            Obx(() {
              if ((chatController.isFirstTime.value || chatController.showSuggestions.value) &&
                  chatController.suggestions.isNotEmpty) {
                return Container(
                  alignment: AlignmentDirectional(-0.8, 1),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: chatController.suggestions.map((suggestion) {
                        return GestureDetector(
                          onTap: () {
                            textController.text = suggestion;
                            chatController.showSuggestions.value = false;
                            chatController.isFirstTime.value = false; // Mark as not first time anymore
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
                              style: const TextStyle(color: Colors.black),
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
                        chatController.isFirstTime.value = false;
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        // In ChatView, modify the endDrawer section:
        endDrawer: Drawer(
          width: Get.width * 0.7,
          child: Container(
            color: AppColors.primarycolor,
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    color: Colors.teal.shade900,
                    child: ListTile(
                      style: ListTileStyle.list,
                      title: Text("New Chat", style: TextStyle(color: Colors.white)),
                      leading: Icon(Icons.edit_note_rounded, color: Colors.white),
                      onTap: () async {
                        await createNewChatSession();
                      },
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Icon(Icons.history,color: Colors.white,),
                              SizedBox(width: 20,),
                              Text(
                                "History",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(),
                              // In your ChatView widget, replace the IconButton in the history section with this:
                              RefreshButton(chatController: chatController),
                            ],
                          ),
                        ),
                        Divider(),
                        Expanded(
                          child: HistoryListWidget(
                            chatController: chatController,
                            sessionId: sessionId,
                            onLoadSession: loadSession,
                            onDeleteHistory: deleteHistory,
                          ),
                        ),
                      ],
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

  Future<void> deleteHistory(int sessionId) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final result = await AuthRepository().deleteHistory(sessionId);
      Get.back(); // Close loading dialog

      if (result != null && result['success'] == true) {
        Get.snackbar("Deleted", "Session has been deleted successfully",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Error", "Failed to delete session",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "An error occurred while deleting: $e",
          snackPosition: SnackPosition.BOTTOM);
      print("Delete error: $e");
    }
  }

  Future<void> createNewChatSession() async {
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
          isNewSession: true,
        );
        newController.isFirstTime.value = true;

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
      print("Error in createNewChatSession: $e");
    }
  }

  Future<void> loadSession(String newSessionId) async {
    try {
      final chatController = Get.find<ChatController>(tag: controllerTag);
      final currentPersonaId = chatController.personaId;
      final token = await TokenStorage.getLoginAccessToken() ?? '';

      // Close drawer first
      Get.back();

      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Save the new session ID
      await TokenStorage.savePersonaSessionId(currentPersonaId, newSessionId);

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
        isNewSession: false, // This is an existing session
      );

      // Put the new controller in GetX
      Get.put(newController, tag: newControllerTag, permanent: true);

      // Close loading dialog
      Get.back();

      // Navigate to chat view
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
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Error loading session: $e");
      print("Error in loadSession: $e");
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