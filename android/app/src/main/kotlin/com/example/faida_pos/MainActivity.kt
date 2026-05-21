package com.example.faida_pos

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.faida_pos/whisper"
    private lateinit var whisperHelper: WhisperHelper

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        whisperHelper = WhisperHelper(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "transcribe" -> {
                        val path = call.argument<String>("path")!!
                        val modelPath = filesDir.absolutePath + "/ggml-base.en.bin"
                        val text = whisperHelper.transcribeAudio(path, modelPath)
                        result.success(text)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
