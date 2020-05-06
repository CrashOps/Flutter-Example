import 'dart:async';
import 'dart:io';

import 'package:crashops_flutter/crashops_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  CrashOps.instance.run(
      app: MyApp(),
      iosKey: "your-ios-application-key-from-crashops",
      androidKey: "your-android-application-key-from-crashops",
      onError: (flutterErrorDetails, globalError, stackTrace) {
        if (flutterErrorDetails != null) {
          // Sometimes 'flutterErrorDetails' may be null because CrashOps catches Dart errors as well, not only Flutter errors.
          //
          // In case you wish to use more error catchers, make calls like this one:
          // Crashlytics.instance.recordFlutterError(flutterErrorDetails);
        }

        print(
            "CrashOps caught an error from Flutter / Dart:\nError: $globalError\nStack Trace: $stackTrace");
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
    crashOps.setApplicationKey(
        iosKey: "your-ios-application-key-from-crashops",
        androidKey: "your-android-application-key-from-crashops");
    // If you wish to add more details in each log
    crashOps.setMetadata({"yo": "that's my awesome app!"});
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
