import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:get/get.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  Stream? _broadcastStream;

  final RxBool _isConnected = false.obs; // Changed to RxBool

  bool get isConnected => _isConnected.value;

  void connect(String sessionId, String token, {int? personaId}) {
    try {
      final uri = Uri.parse(
        "ws://memory-brandon-boost-trustees.trycloudflare.com/ws/chat/$sessionId/?token=$token",
      );
      print('Connecting to WebSocket: $uri');
      _channel = WebSocketChannel.connect(uri);
      _isConnected.value = true;

      _broadcastStream = _channel!.stream.asBroadcastStream()
        ..listen(
              (event) => print('📥 Incoming: $event'),
          onError: (err) {
            print('❌ WebSocket Error: $err');
            _isConnected.value = false;
          },
          onDone: () {
            print('✅ WebSocket Closed');
            _isConnected.value = false;
          },
          cancelOnError: true,
        );
    } catch (e) {
      print('WebSocket connection failed: $e');
      _isConnected.value = false;
    }
  }

  void sendMessage(String msg) {
    if (_channel != null && _isConnected.value) {
      try {
        _channel!.sink.add(jsonEncode({"message": msg}));
        print('📤 Outgoing: $msg');
      } catch (e) {
        print('Error sending message: $e');
      }
    } else {
      print('Cannot send message - WebSocket not connected');
    }
  }

  void disconnect() {
    try {
      _channel?.sink.close();
      _isConnected.value = false;
      print('WebSocket disconnected');
    } catch (e) {
      print('Error disconnecting WebSocket: $e');
    }
  }

  Stream get stream => _broadcastStream ?? const Stream.empty();
}