import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/material.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  io.Socket? socket;
  final String serverUrl = "https://sugarwiseworld.com";

  void connect(String userId) {
    if (socket != null && socket!.connected) return;

    socket = io.io(
      serverUrl,
      io.OptionBuilder()
          .setTransports(['websocket']) // استخدام websocket بشكل أساسي
          .disableAutoConnect()
          .build(),
    );

    debugPrint('📡 Attempting to connect to Socket: $serverUrl');
    socket!.connect();

    socket!.onConnect((_) {
      debugPrint('✅ Connected to Socket Server');
      socket!.emit('setup', {'id': userId});
    });

    socket!.onConnectError((err) => debugPrint('❌ Socket Connect Error: $err'));
    socket!.on(
      'connect_timeout',
      (_) => debugPrint('⏰ Socket Connect Timeout'),
    );
    socket!.onDisconnect(
      (_) => debugPrint('🔌 Disconnected from Socket Server'),
    );
    socket!.onError((err) => debugPrint('⚠️ Socket Error: $err'));
  }

  void joinChat(String room) {
    socket?.emit('join_chat', room);
  }

  void sendMessage(Map<String, dynamic> messageData) {
    socket?.emit('new_message', messageData);
  }

  void sendTyping(String room) {
    socket?.emit('typing', room);
  }

  void sendStopTyping(String room) {
    socket?.emit('stop_typing', room);
  }

  void disconnect() {
    socket?.disconnect();
    socket = null;
  }
}
