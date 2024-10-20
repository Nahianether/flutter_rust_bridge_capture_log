import 'package:flutter/material.dart';
import 'package:system_tray/system_tray.dart';

import '../../rust/api/simple.dart';

class ContentBody extends StatelessWidget {
  final SystemTray systemTray;
  final Menu menu;
  final Map<String, dynamic> deviceData;

  const ContentBody({
    super.key,
    required this.systemTray,
    required this.menu,
    required this.deviceData,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: const Color(0xFFFFFFFF),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          children: [
            Card(
              elevation: 2.0,
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 200,
                      child: ListView(
                        children: deviceData.keys.map(
                          (String property) {
                            return Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    property,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      '${deviceData[property]}',
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async => takeS(path: 'D:/piic/screenshots.png'),
                      child: const Text('Take ScreenShot'),
                    ),
                    const SizedBox(height: 10),
                    // ElevatedButton(
                    //   onPressed: () async {},
                    //   child: const Text('Check URL'),
                    // ),
                    ElevatedButton(
                      onPressed: () async => listenToKeyboardsMain(),
                      child: const Text('Check Mouse Keyboard Running'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        List<String> logs = getRunningProcesses();
                        debugPrint('Logs: $logs');
                      },
                      child: const Text('Get Running Process'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async => fileSystemMonitor(),
                      child: const Text('File System Monitor'),
                    ),
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     List<String> logs =
                    //         getChromeHistory(path: '/Users/intishar/Library/Application Support/Google/Chrome/Default');
                    //     debugPrint('Chrome Log: $logs');
                    //   },
                    //   child: const Text('Get Chrome History'),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
