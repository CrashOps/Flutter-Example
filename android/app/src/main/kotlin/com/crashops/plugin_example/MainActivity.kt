package com.crashops.plugin_example

import androidx.annotation.NonNull
import com.crashops.bridging.FlutterNativeBridge
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    private var flutterNativeBridge: FlutterNativeBridge? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        flutterNativeBridge = FlutterNativeBridge(flutterEngine.dartExecutor)
    }
}
