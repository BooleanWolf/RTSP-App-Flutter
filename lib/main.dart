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
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
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
    'rtsp://admin:Secl1234@192.168.1.108:554/live2',
    'rtsp://admin:Secl1234@192.168.1.108:554/live',
    'rtsp://admin:Secl1234@192.168.1.108:554/live',
    'rtsp://admin:Secl1234@192.168.1.108:554/live',
    'rtsp://admin:Secl1234@192.168.1.108:554/live6',
  ];

  int _selectedCameraIndex = 0;

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
        title: const Text('RTSP Feed Viewer'),
        centerTitle: true,
        elevation: 10.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: VlcPlayer(
                    controller: _controllers[_selectedCameraIndex],
                    aspectRatio: 16 / 9,
                    virtualDisplay: true,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(rtspUris.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedCameraIndex == index
                          ? Colors.deepPurple
                          : Colors.grey[800],
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedCameraIndex = index;
                      });
                    },
                    child: Text('Camera ${index + 1}'),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
