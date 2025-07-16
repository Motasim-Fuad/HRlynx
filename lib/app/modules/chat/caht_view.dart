import 'package:audioplayers/audioplayers.dart';
import 'package:damaged303/app/modules/chat/chat_controller.dart';
import 'package:damaged303/app/modules/chat_history/chat_history.dart';
import 'package:damaged303/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final AudioPlayer audioPlayer = AudioPlayer();

class CahtView extends StatelessWidget {
  final TextEditingController textController = TextEditingController();
  CahtView({super.key, this.chat_name, this.chat_imng});
  final String? chat_name;
  final String? chat_imng;

  @override
  Widget build(BuildContext context) {
    final VoiceController voiceController = Get.put(VoiceController());

    return Scaffold(
      endDrawer: Drawer(
        width: Get.width * .4,
        child: Container(
          color: AppColors.primarycolor,
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.cancel_outlined, color: Colors.white),
                    ),
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
                      Get.to(ChatHistory());
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back_ios_new),
                    ),
                    Container(
                      height: 42,
                      width: 42,
                      child: Image.asset(chat_imng ?? ""),
                    ),
                    Text(
                      chat_name ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        color: Color(0xff050505),
                      ),
                    ),
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        child: Icon(Icons.more_vert_rounded),
                      ),
                    ),
                  ],
                ),
                height: 68,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffE6ECEB),
                  border: Border.all(width: 1, color: AppColors.primarycolor),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  Get.snackbar(
                    "AI-powered responses are provided for informational purposes only and do not constitute legal, compliance, or professional advice. Users should consult qualified HR, legal, or compliance professionals before making employment decisions. HRlynx AI Personas are not a substitute for independent judgment or expert consultation. Content may not reflect the most current regulatory or legal developments. Use of this platform is subject to the Terms of Use and Privacy Policy.  ",
                    "",
                  );
                },
                child: Text(
                  textAlign: TextAlign.center,
                  'AI Guidance Only — Not Legal or HR Advice. Consult professionals for critical decisions.',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: AppColors.primarycolor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: voiceController.messages.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final msg =
                          voiceController.messages[voiceController
                                  .messages
                                  .length -
                              1 -
                              index];
                      final isMe = msg.isMe;
                      return Row(
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!isMe)
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 8.0,
                                left: 8.0,
                                bottom: 4.0,
                              ),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundImage:
                                    chat_imng != null && chat_imng!.isNotEmpty
                                    ? AssetImage(chat_imng!)
                                    : AssetImage(
                                        'assets/images/default_avatar.png',
                                      ),
                              ),
                            ),
                          Flexible(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? AppColors.primarycolor
                                    : Color(0xffE6ECEB),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: msg.audioPath == null
                                  ? Text(
                                      msg.text,
                                      style: TextStyle(
                                        color: isMe
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      softWrap: true,
                                      maxLines: null, // Allow unlimited lines
                                      overflow: TextOverflow.visible,
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.play_arrow,
                                            color: isMe
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          onPressed: () async {
                                            await audioPlayer.play(
                                              DeviceFileSource(msg.audioPath!),
                                            );
                                          },
                                        ),
                                        Text(
                                          'Voice message',
                                          style: TextStyle(
                                            color: isMe
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          if (isMe)
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                                bottom: 4.0,
                              ),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundImage: AssetImage(
                                  'assets/images/profile.png',
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.only(bottom: 10),
                height: 50,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: TextFormField(
                        controller: textController,
                        decoration: InputDecoration(
                          hintText: '   Type a message...',
                          border: InputBorder.none,
                        ),
                        onFieldSubmitted: (value) {
                          voiceController.sendTextMessage(value);
                          textController.clear();
                        },
                      ),
                      width: Get.width * .60,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Color(0xffDDDDDF)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    Obx(
                      () => GestureDetector(
                        onLongPress: () => voiceController.startRecording(),
                        onLongPressUp: () => voiceController.stopRecording(),
                        onLongPressCancel: () =>
                            voiceController.cancelRecording(),
                        child: CircleAvatar(
                          backgroundColor: voiceController.isRecording.value
                              ? Colors.red
                              : Colors.grey.shade600,
                          radius: 20,
                          child: Icon(
                            voiceController.isRecording.value
                                ? Icons.mic_none
                                : Icons.mic,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),

                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primarycolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        voiceController.sendTextMessage(textController.text);
                        textController.clear();
                      },
                      icon: Icon(Icons.send_outlined),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
