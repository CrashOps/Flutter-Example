# CrashOps plugin for Flutter - Sample project

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This Flutter plugin helps to bridge your app with the CrashOps native SDK.
CrashOps library helps you monitor your app's crashes and Flutter errors.

## Installation
### 🔌 & ▶️

[Our plugin](https://pub.dev/packages/crashops_flutter) is pretty straight forward and easy to "plug n' play". All you need to do is adding `crashops_flutter` dependency and CrashOps will automatically start monitoring native crashes on each app launch.

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


### CrashOps can catch also errors from Flutter and Dart, not only native crashes.

To catch errors from your Flutter app, edit your `main()` method as follows:
```dart
void main() {
  CrashOps.instance.run(app: MyApp(), onError: (e, stacktrace) {
    print("Caught error from Flutter / Dart:\nError: $e\nStack Trace: $stacktrace");
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
