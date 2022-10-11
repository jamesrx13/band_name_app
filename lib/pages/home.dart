import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_name_app/models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'MC/DC', votes: 30),
    Band(id: '2', name: 'Metalica', votes: 20),
    Band(id: '3', name: 'Mago de OZ', votes: 10),
    Band(id: '4', name: 'XXXTENTACION', votes: 12),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: const Text('Band Names'),
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) => bandTitle(bands[index]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  ListTile bandTitle(Band banda) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(banda.name.substring(0, 2)),
      ),
      title: Text(banda.name),
      trailing: Text('${banda.votes}'),
      onTap: () {
        debugPrint(banda.name);
      },
    );
  }

  _addNewBand() {
    final textController = TextEditingController();
    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New Band'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                onPressed: () => _addBandToList(textController.text),
                textColor: Colors.blue,
                child: const Text('Add new Band'),
              ),
            ],
          );
        },
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('New Band Name'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Add'),
              onPressed: () => _addBandToList(textController.text),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Dismiss'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  _addBandToList(String name) {
    if (name.length > 1) {
      // ADD
    }

    Navigator.pop(context);
  }
}
