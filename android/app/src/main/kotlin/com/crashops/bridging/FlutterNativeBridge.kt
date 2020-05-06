package com.crashops.bridging

import android.os.Handler
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class FlutterNativeBridge(): MethodChannel.MethodCallHandler {
    companion object {
        private const val SUCCESS_RESULT: String = "1"
        private const val FAILURE_RESULT: String = "0"
        public const val CHANNEL_NAME: String = "crashops-flutter-example/native_channel"
    }

    @Suppress("NO_REFLECTION_IN_CLASS_PATH")
    private val TAG: String = FlutterNativeBridge::class.simpleName.toString()

    private lateinit var methodChannel: MethodChannel

    constructor(messenger: BinaryMessenger) : this() {
        methodChannel = MethodChannel(messenger, CHANNEL_NAME)
        methodChannel.setMethodCallHandler { call, result ->
            onMethodCall(call, result)
        }
        // Method channel now works in both directions
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
        val nativeChannelResult: Any?

        when (call.method) {
            "crash_the_app" -> {
                nativeChannelResult = SUCCESS_RESULT
                Handler().postDelayed({
                    val i = arrayListOf(1, 2, 3, 4, 5)[6]
                    print(i)
                    //throw Exception("called app crash feature! (intentionally made by host app)")
                }, 1000)
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
        } ?: run {
            // It means that the callback will be
        }
    }
}