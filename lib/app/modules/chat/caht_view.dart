import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api_servies/api_Constant.dart';
import '../../utils/app_colors.dart';
import 'chat_controller.dart';
import '../../api_servies/webSocketServices.dart';

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
    final chatController = Get.find<ChatController>(tag: controllerTag); // use tagged controller

    return Obx(() {
      final session = chatController.session.value;
      return Scaffold(
        backgroundColor: Color(0xfff6e9e9),
        appBar: AppBar(
          title: session != null
              ? Builder(
            builder: (context) {
              final screenWidth = MediaQuery.of(context).size.width;
              final avatarSize = screenWidth * 0.08;
              final nameFontSize = screenWidth * 0.045;
              final titleFontSize = screenWidth * 0.03;

              return Row(
                children: [
                  CircleAvatar(
                    radius: avatarSize,
                    backgroundImage: NetworkImage(
                      "${ApiConstants.baseUrl}${session.persona.avatar}",
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Expanded( // 👈 Prevent overflow
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // 👈 Important to avoid height overflow
                      children: [
                        Text(
                          session.persona.name,
                          style: TextStyle(
                            fontSize: nameFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis, // 👈 Safe ellipsis
                        ),
                        Text(
                          session.persona.title,
                          style: TextStyle(
                            fontSize: titleFontSize,
                            color: Colors.grey[700],
                          ),
                          overflow: TextOverflow.ellipsis, // 👈 Safe ellipsis
                        ),

                      ],
                    ),
                  ),

                ],
              );
            },
          )
              : const Text('Loading...'),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.more_vert_outlined),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer(); // now works!
                },
              ),
            ),
          ],

        ),





        body: Column(
          children: [

            // Container(
            //   child:  Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       GestureDetector(
            //         onTap: () {
            //           Get.back();
            //         },
            //         child: Icon(Icons.arrow_back_ios_new),
            //       ),
            //       CircleAvatar(
            //         radius: 34,
            //         backgroundImage: NetworkImage(
            //           "${ApiConstants.baseUrl}${session!.persona.avatar}",
            //         ),
            //       ),
            //       Text(
            //         session!.persona.title,
            //         style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           fontSize: 18,
            //           color: Color(0xff050505),
            //         ),
            //       ),
            //       Builder(
            //         builder: (context) => GestureDetector(
            //           onTap: () {
            //             Scaffold.of(context).openEndDrawer();
            //           },
            //           child: Icon(Icons.more_vert_rounded),
            //         ),
            //       ),
            //     ],
            //   ),
            //   height: 68,
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     color: Color(0xffE6ECEB),
            //     border: Border.all(width: 1, color: AppColors.primarycolor),
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            // ),
            // SizedBox(height: 5),
            // GestureDetector(
            //   onTap: () {
            //     Get.snackbar(
            //       "AI-powered responses are provided for informational purposes only and do not constitute legal, compliance, or professional advice. Users should consult qualified HR, legal, or compliance professionals before making employment decisions. HRlynx AI Personas are not a substitute for independent judgment or expert consultation. Content may not reflect the most current regulatory or legal developments. Use of this platform is subject to the Terms of Use and Privacy Policy.  ",
            //       "",
            //     );
            //   },
            //   child: Text(
            //     textAlign: TextAlign.center,
            //     'AI Guidance Only — Not Legal or HR Advice. Consult professionals for critical decisions.',
            //     style: TextStyle(
            //       decoration: TextDecoration.underline,
            //       color: AppColors.primarycolor,
            //       fontWeight: FontWeight.w400,
            //       fontSize: 12,
            //     ),
            //   ),
            // ),



            TextButton(onPressed: (){
              Get.snackbar(
                        " ","AI-powered responses are provided for informational purposes only and do not constitute legal, compliance, or professional advice. Users should consult qualified HR, legal, or compliance professionals before making employment decisions. HRlynx AI Personas are not a substitute for independent judgment or expert consultation. Content may not reflect the most current regulatory or legal developments. Use of this platform is subject to the Terms of Use and Privacy Policy. "
                      );
            }, child: Text("AI Guidance Only — Not Legal or HR Advice. Consult professionals for critical decisions.",textAlign: TextAlign.center,style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.grey,
              fontSize: 10,

            ),)
            ),

            Expanded(
              child: Obx(() => ListView.builder(
                reverse: false,
                controller: chatController.scrollController, // 👈 use this
                itemCount: chatController.messages.length,
                itemBuilder: (_, i) {
                  final message = chatController.messages[i];
                  final isMe = message.sender == 'me';

                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    alignment: isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isMe)
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: session != null
                                ? NetworkImage(
                                "${ApiConstants.baseUrl}${session.persona.avatar}")
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
                                  message.message,
                                  style: const TextStyle(fontSize: 15),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatTime(message.timestamp), // custom formatted time
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
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
            const Divider(height: 1),
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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.mic_none),
                    onPressed: () {
                      // mic functionality here
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final text = textController.text.trim();
                      if (text.isNotEmpty) {
                        chatController.send(text);
                        textController.clear();
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),


        endDrawer: Drawer(
          width: Get.width * .7,
          child: Container(
            color: AppColors.primarycolor,
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                      SizedBox(width: 20,),
                    ],
                  ),
                  

                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: GestureDetector(
                      onTap: () {
                        print('while backend we will implement this');
                      },
                      child: Row(
                        children: [
                          Icon(Icons.edit_note_rounded, color: Colors.white),
                          SizedBox(width: 3),
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
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: GestureDetector(
                      onTap: () {
                        // Get.to(ChatHistory());
                      },
                      child: Row(
                        children: [
                          Icon(Icons.access_time_outlined, color: Colors.white),
                          SizedBox(width: 3),
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
  String formatTime(DateTime time) {
    final now = DateTime.now();
    final isToday = now.day == time.day &&
        now.month == time.month &&
        now.year == time.year;
    return isToday
        ? "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}"
        : "${time.day}/${time.month}/${time.year}";
  }

}


