import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:system_tray/system_tray.dart';

import '../../../main.dart';
import '../../constants/device.info.data.dart';
import '../../rust/api/simple.dart';
import '../window.view/content.body.dart';
import '../window.view/title.bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  final AppWindow _appWindow = AppWindow();
  final SystemTray _systemTray = SystemTray();
  final Menu _menuMain = Menu();
  final Menu _menuSimple = Menu();

  Timer? _timer;
  bool _toogleTrayIcon = true;

  bool _toogleMenu = true;

  Future<void> _captureScreenshotPeriodically() async {
    const interval = Duration(minutes: 5);
    var i = 0;
    while (mounted) {
      await Future.delayed(interval);
      takeS(path: 'D:/piic/screenshot$i.png');
      // takeS(path: 'F:/screenshot$i.png');
      i++;
    }
  }

  @override
  void initState() {
    // _captureScreenshotPeriodically();
    super.initState();
    initPlatformState();
    initSystemTray();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      deviceData = switch (defaultTargetPlatform) {
        TargetPlatform.linux => readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo),
        TargetPlatform.windows => readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo),
        TargetPlatform.macOS => readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo),
        TargetPlatform.fuchsia => <String, dynamic>{'Error:': 'Fuchsia platform isn\'t supported'},
        TargetPlatform.android => throw UnimplementedError(),
        TargetPlatform.iOS => throw UnimplementedError(),
      };
    } on PlatformException {
      deviceData = <String, dynamic>{'Error:': 'Failed to get platform version.'};
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Future<void> initSystemTray() async {
    // List<String> iconList = ['darts_icon', 'gift_icon'];

    // We first init the systray menu and then add the menu entries
    await _systemTray.initSystemTray(iconPath: getTrayImagePath('app_icon'));
    _systemTray.setTitle("system tray");
    _systemTray.setToolTip("How to use system tray with Flutter");

    // handle system tray event
    _systemTray.registerSystemTrayEventHandler((eventName) {
      debugPrint("eventName: $eventName");
      if (eventName == kSystemTrayEventClick) {
        Platform.isWindows ? _appWindow.show() : _systemTray.popUpContextMenu();
      } else if (eventName == kSystemTrayEventRightClick) {
        Platform.isWindows ? _systemTray.popUpContextMenu() : _appWindow.show();
      }
    });

    await _menuMain.buildFrom(
      [
        MenuItemLabel(
          label: 'Change Context Menu',
          // image: getImagePath('darts_icon'),
          onClicked: (menuItem) {
            debugPrint("Change Context Menu");

            _toogleMenu = !_toogleMenu;
            _systemTray.setContextMenu(_toogleMenu ? _menuMain : _menuSimple);
          },
        ),
        MenuSeparator(),
        MenuItemLabel(
          label: 'Show',
          // image: getImagePath('darts_icon'),
          onClicked: (menuItem) => _appWindow.show(),
        ),
        MenuItemLabel(
          label: 'Hide',
          // image: getImagePath('darts_icon'),
          onClicked: (menuItem) => _appWindow.hide(),
        ),
        MenuItemLabel(
          label: 'Start flash tray icon',
          // image: getImagePath('darts_icon'),
          onClicked: (menuItem) {
            debugPrint("Start flash tray icon");

            _timer ??= Timer.periodic(
              const Duration(milliseconds: 500),
              (timer) {
                _toogleTrayIcon = !_toogleTrayIcon;
                _systemTray.setImage(_toogleTrayIcon ? "" : getTrayImagePath('app_icon'));
              },
            );
          },
        ),
        MenuItemLabel(
          label: 'Stop flash tray icon',
          // image: getImagePath('darts_icon'),
          onClicked: (menuItem) {
            debugPrint("Stop flash tray icon");

            _timer?.cancel();
            _timer = null;

            _systemTray.setImage(getTrayImagePath('app_icon'));
          },
        ),
        MenuSeparator(),
        MenuItemLabel(
          label: 'Exit',
          onClicked: (menuItem) => _appWindow.close(),
        ),
      ],
    );

    await _menuSimple.buildFrom([
      MenuItemLabel(
        label: 'Change Context Menu',
        image: getImagePath('app_icon'),
        onClicked: (menuItem) {
          debugPrint("Change Context Menu");

          _toogleMenu = !_toogleMenu;
          _systemTray.setContextMenu(_toogleMenu ? _menuMain : _menuSimple);
        },
      ),
      MenuSeparator(),
      MenuItemLabel(
        label: 'Show',
        image: getImagePath('app_icon'),
        onClicked: (menuItem) => _appWindow.show(),
      ),
      MenuItemLabel(
        label: 'Hide',
        image: getImagePath('app_icon'),
        onClicked: (menuItem) => _appWindow.hide(),
      ),
      MenuItemLabel(
        label: 'Exit',
        image: getImagePath('app_icon'),
        onClicked: (menuItem) => _appWindow.close(),
      ),
    ]);

    _systemTray.setContextMenu(_menuMain);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TitleBar(),
            ContentBody(
              systemTray: _systemTray,
              menu: _menuMain,
              deviceData: _deviceData,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
         await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Uninstall App'),
                content: const Text('Are you sure you want to uninstall this app?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // uninstallApp();
                    },
                    child: const Text('Uninstall'),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Uninstall App',
        child: const Icon(Icons.delete),
      ),
    );
  }
}
