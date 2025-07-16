import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

import 'package:damaged303/app/modules/chat/chat_model.dart';

class VoiceController extends GetxController {
  final _recorder = AudioRecorder(); // ✅ Use this instead of Record()
  var isRecording = false.obs;
  String? lastRecordedFile;

  var messages = <ChatMessage>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (messages.isEmpty) {
      messages.addAll(dummyMessages);
    }
  }

  void sendTextMessage(String text) {
    if (text.trim().isNotEmpty) {
      messages.add(
        ChatMessage(text: text.trim(), isMe: true, time: DateTime.now()),
      );
    }
  }

  // Removed duplicate onInit

  Future<void> startRecording() async {
    final permission = await Permission.microphone.request();
    if (!permission.isGranted) return;

    if (await _recorder.hasPermission()) {
      final dir = await getApplicationDocumentsDirectory();
      final filePath =
          '${dir.path}/recorded_audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorder.start(const RecordConfig(), path: filePath);
      isRecording.value = true;
    }
  }

  Future<void> stopRecording() async {
    final path = await _recorder.stop();
    isRecording.value = false;

    if (path != null) {
      lastRecordedFile = path;
      print("Recorded file path: $path");
      // Add a message to the chat when recording is stopped, with audioPath
      messages.add(
        ChatMessage(
          text: '[Voice message]',
          isMe: true,
          time: DateTime.now(),
          audioPath: path, // Store the audio file path
        ),
      );
    }
  }

  Future<void> cancelRecording() async {
    await _recorder.stop();
    isRecording.value = false;
    print("Recording cancelled");
  }
}
