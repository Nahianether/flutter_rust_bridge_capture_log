import 'package:flutter/material.dart';
import 'package:flutter_rust_bridge_test/src/rust/api/simple.dart';
import 'package:flutter_rust_bridge_test/src/rust/frb_generated.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _captureScreenshotPeriodically() async {
    const interval = Duration(minutes: 5);
    var i = 0;
    while (mounted) {
      await Future.delayed(interval);
      takeS(path: '/Users/intishar/Pictures/screenshot$i.png');
      // takeS(path: 'F:/screenshot$i.png');
      i++;
    }
  }

  @override
  void initState() {
    // _captureScreenshotPeriodically();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('flutter_rust_bridge quickstart')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Action: Call Rust `greet("Tom")`\nResult: `${greet(name: "Tom")}`'),
              ElevatedButton(
                onPressed: () async {
                  takeS(path: '/Users/intishar/Pictures/screenshot.png');
                },
                child: const Text('Take ScreenShot'),
              ),
              ElevatedButton(
                onPressed: () async {
                  List<String> logs = getRunningProcesses();
                  debugPrint('Logs: $logs');
                },
                child: const Text('Get Running Process'),
              ),
              ElevatedButton(
                onPressed: () async {
                  List<String> logs =
                      getChromeHistory(path: '/Users/intishar/Library/Application Support/Google/Chrome/Default');
                  debugPrint('Chrome Log: $logs');
                },
                child: const Text('Get Chrome History'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
