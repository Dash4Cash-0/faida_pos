cmake_minimum_required(VERSION 3.22.1)
project(whisper_cpp)

set(WHISPER_SRC /home/dash4cash/Java/faida_pos/whisper.cpp)

add_library(
    whisper
    SHARED
    app/src/main/cpp/whisper_jni.cpp
    ${WHISPER_SRC}/whisper.cpp
    ${WHISPER_SRC}/ggml.c
    ${WHISPER_SRC}/ggml-alloc.c
    ${WHISPER_SRC}/ggml-backend.c
    ${WHISPER_SRC}/ggml-quants.c
)

target_include_directories(whisper PRIVATE
    ${WHISPER_SRC}
)

target_link_libraries(whisper
    android
    log
    c++_shared
)