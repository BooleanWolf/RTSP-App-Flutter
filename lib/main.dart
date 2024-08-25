import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RTSP Feeds',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiFeedPage(),
    );
  }
}

class MultiFeedPage extends StatefulWidget {
  @override
  _MultiFeedPageState createState() => _MultiFeedPageState();
}

class _MultiFeedPageState extends State<MultiFeedPage> {
  List<VlcPlayerController> _controllers = [];

  final List<String> rtspUris = [
    'rtsp://admin:Secl1234@192.168.1.108:554/live',
    'rtsp://admin:Secl1234@192.168.1.108:554/live',
    'rtsp://admin:Secl1234@192.168.1.108:554/live',
    'rtsp://admin:Secl1234@192.168.1.108:554/live',
    'rtsp://admin:Secl1234@192.168.1.108:554/live',
    'rtsp://admin:Secl1234@192.168.1.108:554/live', // Add a 6th feed
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _controllers = rtspUris.map((uri) {
      return VlcPlayerController.network(
        uri,
        autoPlay: true,
        options: VlcPlayerOptions(),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RTSP Feeds'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          childAspectRatio: 16 / 9, // Aspect ratio of each grid item
          crossAxisSpacing: 4.0, // Horizontal space between items
          mainAxisSpacing: 4.0, // Vertical space between items
        ),
        itemCount: rtspUris.length,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.black,
            child: VlcPlayer(
              controller: _controllers[index],
              aspectRatio: 16 / 9,
              virtualDisplay: true,
            ),
          );
        },
      ),
    );
  }
}
