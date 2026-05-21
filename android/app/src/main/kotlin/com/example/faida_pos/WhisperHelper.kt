package com.example.faida_pos

class WhisperHelper {

    companion object {
        init {
            System.loadLibrary("whisper")
        }
    }

    external fun transcribeAudio(audioPath: String, modelPath: String): String
}