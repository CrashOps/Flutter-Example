# CrashOps plugin for Flutter - Sample project

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This Flutter plugin helps to bridge your app with the CrashOps native SDK.
CrashOps library helps you monitor your app's crashes and Flutter errors.

## Installation
### 🔌 & ▶️

Easiest to install, it's a "plug n' play" plugin. All you need to do is adding `crashops_flutter` dependency and CrashOps will automatically start monitoring on each app launch.

Required changes in your `pubspec.yaml` file:
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
  // It's not mandatory to put those configurations inside a State.
  // It may also be in the "main()" function.
  final CrashOps crashOps = CrashOps();

  ...

  @override
  void initState() {
    super.initState();

    // If you're willing to create logs in debug
    crashOps.isEnabledInDebugMode = true;
    // If you wish to upload logs to CrashOps servers
    crashOps.setClientId("your-client-id-from-crashops");
    // If you wish to add more details in each log
    crashOps.setMetadata({"yo": "that's my awesome app!"});
  }

  ...

}
```
## Configuration Files
These files are **not mandatory** to use as you can also configure CrashOps via code only (programmatically, as appears above), but you still can add these files to save yourself coding.

### iOS 'plist' configuration file

[CrashOpsConfig-info.plist](https://github.com/CrashOps/Flutter-Example/blob/v0.0.822/ios/Runner/CrashOpsConfig-info.plist)

### Android 'xml' configuration file

[crashops_config.xml](https://github.com/CrashOps/Flutter-Example/blob/v0.0.822/android/app/src/main/res/values/crashops_config.xml)


## Don't have [Flutter](https://flutter.dev/) yet?

For help getting started with Flutter, view their
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Acknowledgments

[iOS](https://github.com/CrashOps/iOS-SDK/): [KSCrash](https://github.com/kstenerud/KSCrash) library.

[Android](https://github.com/CrashOps/Android-SDK/): [retrofit](https://square.github.io/retrofit/).

[Flutter](https://pub.dev/packages/crashops_flutter): https://pub.dev/flutter



### TODO
Become production ready :)

Our SDK is still under development, stay tuned: [CrashOps.com](https://www.crashops.com/)
