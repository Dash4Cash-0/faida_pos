#include <jni.h>
#include <string>
#include "whisper.h"

extern "C" JNIEXPORT jstring JNICALL
Java_com_example_faida_1pos_WhisperHelper_transcribeAudio(
        JNIEnv* env,
        jobject /* this */,
        jstring audioPath,
        jstring modelPath) {

    const char* model = env->GetStringUTFChars(modelPath, nullptr);
    const char* audio = env->GetStringUTFChars(audioPath, nullptr);

    std::string result = "JNI bridge working!";

    env->ReleaseStringUTFChars(modelPath, model);
    env->ReleaseStringUTFChars(audioPath, audio);

    return env->NewStringUTF(result.c_str());
}