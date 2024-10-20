import 'package:flutter/material.dart';

Widget errorCallbackWidget(Object error, StackTrace stackTrace) {
  // logE(msg: 'Error: $error');
  return Center(
    child: Text(
      '$error',
      style: const TextStyle(color: Colors.red),
    ),
  );
}

Widget errorCallbackWidgetWithStackTrace(Object error, StackTrace stackTrace) {
  // logE(msg: 'Error: $error\n$stackTrace');
  return Center(
    child: Text(
      '$error\n$stackTrace',
      style: const TextStyle(color: Colors.red),
    ),
  );
}

Widget loadingCallbackTextWidget() => const Center(
      child: Text('Loading...'),
    );

Widget loadingCallbackIconWidget([double h = 50, double w = 50]) => Center(
      child: Image.asset('assets/icon/f_sync.png', height: h, width: w),
    );

Widget loadingCallbackProgressWidget([double h = 50, double w = 50]) => Center(
      child: SizedBox(
        height: h,
        width: w,
        child: const CircularProgressIndicator(),
      ),
    );
