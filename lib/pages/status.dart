import 'package:band_name_app/services/socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<Socket>(context);
    return const Scaffold(
      body: Center(
        child: Text('Hello'),
      ),
    );
  }
}
