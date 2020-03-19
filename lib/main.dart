import 'dart:async';
import 'dart:io';

import 'package:crashops_flutter/crashops_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Catching errors in Flutter actually depends on the Flutter developer's code.
  CrashOps crashOps = CrashOps();

  var onErrorPreviousCallback = FlutterError.onError;

  // Catches only Flutter errors
  FlutterError.onError = (FlutterErrorDetails details) {
    crashOps.onError(details);
    FlutterError.dumpErrorToConsole(details, forceReport: false);
    if (onErrorPreviousCallback != null &&
        FlutterError.dumpErrorToConsole != onErrorPreviousCallback) {
      onErrorPreviousCallback(details);
    }
  };

  // Catches all Dart
  runZoned(() {
    runApp(MyApp());
  }, onError: (error, stackTrace) {
    // This catches also Dart errors, not only Flutter errors.
    // For more details, read: https://flutter.dev/docs/cookbook/maintenance/error-reporting
    crashOps.onError(error, stackTrace);

    if (error is FlutterErrorDetails) {
      FlutterErrorDetails details = error;

      FlutterError.dumpErrorToConsole(details, forceReport: false);
      if (onErrorPreviousCallback != null &&
          FlutterError.dumpErrorToConsole != onErrorPreviousCallback) {
        onErrorPreviousCallback(details);
      }
    }
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final CrashOps crashOps = CrashOps();
  bool _isCrashOpsEnabled;
  String get _btnEnableTitle => _isCrashOpsEnabled ? "enabled" : "disabled";

  @override
  void initState() {
    super.initState();

    // If you're willing to create logs in debug
    crashOps.isEnabledInDebugMode = true;
    // If you wish to upload logs CrashOps servers
    crashOps.setClientId("your-client-id-from-crashops");
    // If you wish to add more details in each log
    crashOps.setMetadata({"yo": "that's my awesome app!"});

    try {
      // Platform messages may fail, so we use a try/catch PlatformException.
    } on PlatformException {
      print("Error!");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Platform messages are asynchronous, so we initialize in an async method.
    if (_isCrashOpsEnabled == null) {
      crashOps.isEnabled.then((isOn) {
        _isCrashOpsEnabled = isOn;
        setState(() {});
      });

      return Container();
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CrashOps plugin example'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Running on: ${Platform.operatingSystem}\n'),
              RaisedButton(
                onPressed: () async {
                  _isCrashOpsEnabled = await crashOps.isEnabled;
                  bool didUpdate =
                      await crashOps.setEnabled(!_isCrashOpsEnabled);
//                  didUpdate = await crashOps.setMetadata({"uid": "someUid"});

                  print("did update enabled status: $didUpdate");

                  if (didUpdate) {
                    _isCrashOpsEnabled = await crashOps.isEnabled;
                    setState(() {});
                  }
                },
                child: Text(_btnEnableTitle),
              ),
              RaisedButton(
                onPressed: () async {
                  String nullString;
                  print(nullString.split("nonce").toString());
                },
                child: Text("Cause error! 🐞"),
              ),
              RaisedButton(
                onPressed: () async {
                  NativeBridge.crashThisApp().then((didSucceed) {
                    if (didSucceed) {
                      print("this line cannot be printed, ever!");
                    }
                  });
                },
                child: Text("Crash app! 😱"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NativeBridge {
  static const platform =
      const MethodChannel('crashops-flutter-example/native_channel');

  static const String SUCCESS_RESULT = "1";
  static const String FAILURE_RESULT = "0";

  static Future<bool> crashThisApp() async {
    String result = await _invokeNativeMethod("crash_the_app");
    return result == SUCCESS_RESULT;
  }

  static Future<String> _invokeNativeMethod(String methodName,
      [dynamic arguments]) async {
    String result;
    try {
      if (arguments == null) {
        result = await platform.invokeMethod(methodName);
      } else {
        result = await platform.invokeMethod(methodName, arguments);
      }
      print("Native method '$methodName' returned result: $result");
    } on PlatformException catch (e) {
      String errorMessageString =
          "Failed to run native method, error: '${e.message}'.";
      print(errorMessageString);
    }

    return result;
  }
}
