package com.example.faida_pos

class WhisperHelper(private val context: android.content.Context) {

    private val channel = "com.example.faida_pos/whisper"

    companion object {
        init {
            System.loadLibrary("whisper")
        }
    }

    external fun transcribeAudio(audioPath: String, modelPath: String): String
}