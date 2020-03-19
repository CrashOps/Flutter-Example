package com.example.bridging

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.FlutterView

class FlutterNativeBridge(): MethodChannel.MethodCallHandler {
    companion object {
        private const val SUCCESS_RESULT: String = "1"
        private const val FAILURE_RESULT: String = "0"
    }

    @Suppress("NO_REFLECTION_IN_CLASS_PATH")
    private val TAG: String = FlutterNativeBridge::class.simpleName.toString()
    private val CHANNEL_NAME: String = "crash-app"

    private lateinit var methodChannel: MethodChannel

    constructor(flutterView: FlutterView) : this() {
        methodChannel = MethodChannel(flutterView, CHANNEL_NAME)
        // [Android] method channel works now in both directions
        methodChannel.setMethodCallHandler { call, result ->
            onMethodCall(call, result)
        }
    }

    fun callFlutter(methodName: String, args: Any? = null, callback: ChannelCallback? = null) {
        callback?.let {
            methodChannel.invokeMethod(methodName, args, it)
        } ?: run {
            methodChannel.invokeMethod(methodName, args)
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        // Nullify in case the result will be called asynchronously
        var nativeChannelResult: Any? = null

        when (call.method) {
            "crash-app" -> {
                nativeChannelResult = SUCCESS_RESULT
                throw Exception("called app crash feature! (intentionally made by host app)")
            }
            "something-else" -> {
                // Do something else
                nativeChannelResult = null
            }
            else -> {
                print("Missing handling for method channel named: " + call.method)
                nativeChannelResult = FAILURE_RESULT
            }
        }

        nativeChannelResult?.let {
            result.success(nativeChannelResult)
        }
    }
}