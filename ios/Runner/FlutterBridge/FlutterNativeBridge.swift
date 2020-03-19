//
//  FlutterNativeBridge.swift
//  Runner
//
//  Created by CrashOps on 19/03/2019.
//  Copyright © 2019 CrashOps. All rights reserved.
//

import CrashOps

struct Constants {
    struct FlutterMethodChannel {
        static let SUCCESS_RESULT = "1"
        static let FAILURE_RESULT = "0"
    }
}

extension FlutterViewController {
    static var FlutterMethodChannelName: String = "crashops-flutter-example/native_channel"
    func observeMethodChannel(onFlutterCall: @escaping ((FlutterMethodCall, @escaping FlutterResult) -> Void)) {
        let methodChannel = FlutterMethodChannel(name: FlutterViewController.FlutterMethodChannelName, binaryMessenger: self.binaryMessenger)
        
        methodChannel.setMethodCallHandler(onFlutterCall)
    }
    
    func callFlutter(methodName: String, arguments: Any? = nil, callback: ((Any?) -> ())? = nil) {
        let methodChannel = FlutterMethodChannel(name: FlutterViewController.FlutterMethodChannelName, binaryMessenger: self.binaryMessenger)
        methodChannel.invokeMethod(methodName, arguments: arguments) { (callbackData) in
            print("method: \(methodName) returned: \(String(describing: callbackData))")
            callback?(callbackData)
        }
    }
}

extension UIViewController {
    func scanForViewController(predicate: (UIViewController) -> Bool) -> UIViewController? {
        if predicate(self) {
            return self
        }

        let found = (self as? UINavigationController)?.viewControllers.first(where: predicate)

        if found != nil {
            return found
        }

        return self.presentedViewController?.scanForViewController(predicate: predicate)
    }
}

extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    static func observeFlutterCalls(rootViewController: UIViewController) {
        let flutterViewController: FlutterViewController? = rootViewController.scanForViewController { (viewController) -> Bool in
            return viewController is FlutterViewController
            } as? FlutterViewController

        if let flutterViewController = flutterViewController {
//            Call it only of you havn't in [AppDelegate didFinishLaunchingWithOptions]: GeneratedPluginRegistrant.register(with: flutterViewController)
            flutterViewController.observeMethodChannel { (methodCall, result) in
                AppDelegate.shared.onFlutterCall(call: methodCall, result: result)
            }

        }
    }

    func onFlutterCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let resultString: Any?

        switch call.method {
        case "crash_the_app":
            // Will work only in debug mode
            CrashOps.shared().crash()
            resultString = Constants.FlutterMethodChannel.SUCCESS_RESULT // This line will run only in release mode
        default:
            print("Unhandled bridged Flutter method call: \(call.method)")
            resultString = Constants.FlutterMethodChannel.FAILURE_RESULT // Never return nil!
        }

        if let resultString = resultString {
            // In this case there's a "synchronized" result
            result(resultString)
        } else {
            // In this case there's an async result
            // Note: make sure that some callback will run the `result(..)` closure so the native result will return!
        }
    }
}
