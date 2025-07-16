class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime time;
  final String? audioPath; // Add this for voice messages

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    this.audioPath,
  });
}

final List<ChatMessage> dummyMessages = [
  ChatMessage(
    text: "Hello!",
    isMe: false,
    time: DateTime.now().subtract(Duration(minutes: 10)),
  ),
  ChatMessage(
    text: "Hi, how are you?",
    isMe: true,
    time: DateTime.now().subtract(Duration(minutes: 9)),
  ),
  ChatMessage(
    text: "I'm good, thanks! How about you?",
    isMe: false,
    time: DateTime.now().subtract(Duration(minutes: 8)),
  ),
  ChatMessage(
    text: "I'm great! Working on a Flutter project.",
    isMe: true,
    time: DateTime.now().subtract(Duration(minutes: 7)),
  ),
  ChatMessage(
    text: "That sounds interesting.",
    isMe: false,
    time: DateTime.now().subtract(Duration(minutes: 6)),
  ),
  ChatMessage(
    text: "Yes, it's a chat UI with voice recording.",
    isMe: true,
    time: DateTime.now().subtract(Duration(minutes: 5)),
  ),
  ChatMessage(
    text: "Wow! Can you send me the code?",
    isMe: false,
    time: DateTime.now().subtract(Duration(minutes: 4)),
  ),
  ChatMessage(
    text: "Sure, I'll share it soon.",
    isMe: true,
    time: DateTime.now().subtract(Duration(minutes: 3)),
  ),
  ChatMessage(
    text: "Thank you!",
    isMe: false,
    time: DateTime.now().subtract(Duration(minutes: 2)),
  ),
  ChatMessage(
    text: "You're welcome!",
    isMe: true,
    time: DateTime.now().subtract(Duration(minutes: 1)),
  ),
];
