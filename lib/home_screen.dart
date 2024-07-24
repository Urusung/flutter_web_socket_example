import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _AppState();
}

class _AppState extends State<HomeScreen> {
  late final WebSocketChannel _channel;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _channel =
        WebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Web Socket Example"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _channel.sink.add(_controller.text.toString());
        },
        child: const Icon(Icons.send),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
            ),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data);
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
