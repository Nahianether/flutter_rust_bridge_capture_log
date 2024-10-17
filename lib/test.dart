// import 'dart:async';
// import 'dart:io';
// import 'dart:math';

// import 'package:bitsdojo_window/bitsdojo_window.dart';
// import 'package:english_words/english_words.dart';
// import 'package:flutter/material.dart';
// import 'package:system_tray/system_tray.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     const MyApp(),
//   );

//   doWhenWindowReady(() {
//     final win = appWindow;
//     const initialSize = Size(600, 450);
//     win.minSize = initialSize;
//     win.size = initialSize;
//     win.alignment = Alignment.center;
//     win.title = "How to use system tray with Flutter";
//     win.show();
//   });
// }



// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: WindowBorder(
//           color: const Color(0xFF805306),
//           width: 1,
//           child: Column(
//             children: [
//               const TitleBar(),
//               ContentBody(
//                 systemTray: _systemTray,
//                 menu: _menuMain,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// const backgroundStartColor = Color(0xFFFFD500);
// const backgroundEndColor = Color(0xFFF6A00C);

// class TitleBar extends StatelessWidget {
//   const TitleBar({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return WindowTitleBarBox(
//       child: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [backgroundStartColor, backgroundEndColor],
//               stops: [0.0, 1.0]),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: MoveWindow(),
//             ),
//             const WindowButtons()
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ContentBody extends StatelessWidget {
//   final SystemTray systemTray;
//   final Menu menu;

//   const ContentBody({
//     Key? key,
//     required this.systemTray,
//     required this.menu,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         color: const Color(0xFFFFFFFF),
//         child: ListView(
//           padding: const EdgeInsets.symmetric(vertical: 4.0),
//           children: [
//             Card(
//               elevation: 2.0,
//               margin: const EdgeInsets.symmetric(
//                 horizontal: 16.0,
//                 vertical: 8.0,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'systemTray.initSystemTray',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const Text(
//                       'Create system tray.',
//                     ),
//                     const SizedBox(
//                       height: 12.0,
//                     ),
//                     ElevatedButton(
//                       child: const Text("initSystemTray"),
//                       onPressed: () async {
//                         if (await systemTray.initSystemTray(
//                             iconPath: getTrayImagePath('app_icon'))) {
//                           systemTray.setTitle("new system tray");
//                           systemTray.setToolTip(
//                               "How to use system tray with Flutter");
//                           systemTray.setContextMenu(menu);
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Card(
//               elevation: 2.0,
//               margin: const EdgeInsets.symmetric(
//                 horizontal: 16.0,
//                 vertical: 8.0,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'systemTray.destroy',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const Text(
//                       'Destroy system tray.',
//                     ),
//                     const SizedBox(
//                       height: 12.0,
//                     ),
//                     ElevatedButton(
//                       child: const Text("destroy"),
//                       onPressed: () async {
//                         await systemTray.destroy();
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// final buttonColors = WindowButtonColors(
//     iconNormal: const Color(0xFF805306),
//     mouseOver: const Color(0xFFF6A00C),
//     mouseDown: const Color(0xFF805306),
//     iconMouseOver: const Color(0xFF805306),
//     iconMouseDown: const Color(0xFFFFD500));

// final closeButtonColors = WindowButtonColors(
//     mouseOver: const Color(0xFFD32F2F),
//     mouseDown: const Color(0xFFB71C1C),
//     iconNormal: const Color(0xFF805306),
//     iconMouseOver: Colors.white);

// class WindowButtons extends StatelessWidget {
//   const WindowButtons({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         MinimizeWindowButton(colors: buttonColors),
//         MaximizeWindowButton(colors: buttonColors),
//         CloseWindowButton(
//           colors: closeButtonColors,
//           onPressed: () {
//             showDialog<void>(
//               context: context,
//               barrierDismissible: false,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   title: const Text('Exit Program?'),
//                   content: const Text(
//                       ('The window will be hidden, to exit the program you can use the system menu.')),
//                   actions: <Widget>[
//                     TextButton(
//                       child: const Text('OK'),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                         appWindow.hide();
//                       },
//                     ),
//                   ],
//                 );
//               },
//             );
//           },
//         ),
//       ],
//     );
//   }
// }