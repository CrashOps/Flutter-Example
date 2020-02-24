# CrashOps plugin for Flutter - Sample project

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This Flutter plugin helps to bridge with the CrashOps native SDK.
CrashOps SDK helps you monitor your app's native crashes (we plan to add support for Flutter errors as well in future versions).

## Installation

Easiest to install, it's a plug n' play plugin.
All you need to do is add this dependency ("crashops_flutter") and the SDK will automatically start monitoring after each application launch.

Install by adding `crashops_flutter` to your `pubspec.yaml` file, for example:
```
dependencies:
  flutter:
    sdk: flutter
...
  crashops_flutter: any
...
```

## Usage


### Catch errors

To catch errors from your Flutter app, edit your `main()` method as follows:
```dart
void main() {
  // Catching errors in Flutter actually depends on the Flutter developer's code.
  CrashOps crashOps = CrashOps();

  var onErrorPreviousCallback = FlutterError.onError;
  
  // Catches only Flutter errors
  FlutterError.onError = (FlutterErrorDetails details) {
    crashOps.onError(details);
    FlutterError.dumpErrorToConsole(details, forceReport: false);
    if (onErrorPreviousCallback != null && FlutterError.dumpErrorToConsole != onErrorPreviousCallback) {
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
      if (onErrorPreviousCallback != null && FlutterError.dumpErrorToConsole != onErrorPreviousCallback) {
        onErrorPreviousCallback(details);
      }
    }
  });
}
```


### Custom configurations
```dart
class _MyAppState extends State<MyApp> {
  final CrashOps crashOps = CrashOps();
  
  ...

  @override
  void initState() {
    super.initState();

    // If you're willing to create logs in debug
    crashOps.isEnabledInDebugMode = true;
    // If you wish to upload logs CrashOps servers
    crashOps.setClientId(
        "the-client-id-you-received-from-crashops-customer-support");
    // If you wish to upload logs CrashOps servers
    crashOps.setMetadata({"yo": "that's my awesome app!"});

    try {
      // Platform messages may fail, so we use a try/catch PlatformException.
    } on PlatformException {
      print("Error!");
    }
  }
  
  ...
  
}
```

## Don't have Flutter yet?

For help getting started with Flutter, view its [online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Acknowledgments

[iOS](https://github.com/CrashOps/iOS-SDK/): [KSCrash](https://github.com/kstenerud/KSCrash) library.

[Android](https://github.com/CrashOps/Android-SDK/): Currently none.

[Flutter](https://pub.dev/packages/crashops_flutter): https://pub.dev/flutter




## TODO
Be production ready :)

Our SDK is still under development, stay tuned: [CrashOps.com](https://www.crashops.com/)
