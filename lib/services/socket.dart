import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class Socket with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;

  Socket() {
    _initConfig();
  }

  void _initConfig() {
    IO.Socket socket = IO.io("http://172.20.10.4:3000", {
      'transports': ['websocket'],
      'autoConnect': true
    });
    socket.on('connect', (data) => {debugPrint('Connect')});
    socket.on('disconnect', (data) => debugPrint('Desconectado'));
  }
}
