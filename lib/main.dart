import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late WebSocketChannel channel;
  final controller = TextEditingController();

  List<String> messages = [];

  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(
      Uri.parse('wss://wssimple.arinov.conm'),
    );

    channel.stream.listen((event) {
      setState(() {
        messages.add(event.toString());
      });
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('WebSocket ListView Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(messages[index]),
                    );
                  },
                )
              ),

              SizedBox(height: 10),

              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Kirim pesan',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  final text = controller.text;
                  if (controller.text.isNotEmpty) {
                    channel.sink.add(controller.text);
                    controller.clear();
                  }
                },
                child: Text("Kirim"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}