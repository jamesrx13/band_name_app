import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import 'package:band_name_app/models/band.dart';
import 'package:band_name_app/services/socket.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    bands = (payload as List).map((banda) => Band.fromMap(banda)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'Band Names',
          style: TextStyle(color: Colors.black54),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: socketService.serverStatus == ServerStatus.Online
                ? Icon(
                    Icons.check_circle,
                    color: Colors.blue[300],
                  )
                : const Icon(
                    Icons.offline_bolt,
                    color: Colors.redAccent,
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          _showChart(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, index) => bandTitle(bands[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget bandTitle(Band banda) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(banda.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) =>
          socketService.socket.emit('delete-band', {'id': banda.id}),
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(left: 10.0),
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Delete Band',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(banda.name.substring(0, 2)),
        ),
        title: Text(banda.name),
        trailing: Text('${banda.votes}'),
        onTap: () => socketService.socket.emit('vote-band', {'id': banda.id}),
      ),
    );
  }

  _addNewBand() {
    final textController = TextEditingController();
    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
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
        ),
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
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (name.length > 1) {
      socketService.socket.emit('add-new-band', {'name': name});
    }
    Navigator.pop(context);
  }

  Widget _showChart() {
    Map<String, double> data = {};
    for (var banda in bands) {
      data.putIfAbsent(banda.name, () => banda.votes.toDouble());
    }
    return bands.isNotEmpty
        ? SizedBox(
            width: double.infinity,
            height: 200.0,
            child: PieChart(
              dataMap: data,
              chartType: ChartType.ring,
            ),
          )
        : Container();
  }
}
