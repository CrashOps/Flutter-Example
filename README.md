# CrashOps plugin for Flutter - Sample project

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This Flutter plugin helps to bridge your app with the CrashOps native SDK.
CrashOps library helps you monitor your app's crashes and Flutter errors.

## Installation

### 🔌 & ▶️ (plug n' play)

[Our plugin](https://pub.dev/packages/crashops_flutter) is pretty straight forward and easy to install, all you need to do is add `crashops_flutter` dependency and the SDK will automatically start monitoring native crashes on each app launch.

Required changes in your `pubspec.yaml` file:
```yaml
dependencies:
  flutter:
    sdk: flutter
...
  crashops_flutter: 0.2.33
...
```

## Usage

### CrashOps can catch also errors from Flutter and Dart, not only native crashes.

To catch errors from your Flutter app, edit your `main()` method as follows:
```dart
void main() {
  CrashOps.instance.run(
      app: MyApp(),
      iosKey: "your-ios-application-key-from-crashops-console",
      androidKey: "your-android-application-key-from-crashops-console",
      onError: (flutterErrorDetails, globalError, stackTrace) {
        if (flutterErrorDetails != null) {
          // Sometimes 'flutterErrorDetails' may be null because CrashOps catches Dart errors as well, not only Flutter errors.
          //
          // In case you wish to use more error catchers, make calls like this one:
          // Crashlytics.instance.recordFlutterError(flutterErrorDetails);
        }

        print("CrashOps caught an error from Flutter / Dart:\nError: $globalError\nStack Trace: $stackTrace");
      });
}
```

### Customize configurations as you like
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
    // If you wish to upload logs to CrashOps' servers
    crashOps.setApplicationKey(
        iosKey: "your-ios-application-key-from-crashops-console",
        androidKey: "your-android-application-key-from-crashops-console");
    // If you wish to include more details in each log
    crashOps.setMetadata({"yo": "that's my awesome app!"});
  }

  ...

}
```

## Configuration

### Config Files (use them for application key if not configured programmatically as appears above)

These files are **not mandatory** to use as you can also configure CrashOps via code only (programmatically, as mentioned above), but you still can add these files to save configuration via coding.

#### iOS 'plist' configuration file

[CrashOpsConfig-info.plist](https://github.com/CrashOps/Flutter-Example/blob/v0.1.11/ios/Runner/CrashOpsConfig-info.plist)

#### Android 'xml' configuration file

[crashops_config.xml](https://github.com/CrashOps/Flutter-Example/blob/v0.1.11/android/app/src/main/res/values/crashops_config.xml)


## Don't have [Flutter](https://flutter.dev/) yet?

To help you getting started with Flutter, view their
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Acknowledgments

Our [iOS](https://github.com/CrashOps/iOS-SDK/) SDK uses [KSCrash](https://github.com/kstenerud/KSCrash) library.

Our [Android](https://github.com/CrashOps/Android-SDK/) SDK uses [retrofit](https://square.github.io/retrofit/).

Thanks to this awesome framework called [Flutter](https://pub.dev/flutter), we cloud export [this package](https://pub.dev/packages/crashops_flutter).


### TODO

We're working hard on creating a dashboard on the web, [stay tuned](https://www.crashops.com/).
