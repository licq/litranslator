# litranslator

This is the source code for the ios App LiTranslator. LiTranslator is a live audio translation app. 

## Notes
The app is written by SwiftUI and SwiftData.

The app uses **whisper.cpp** for local speech recognition and **silero** for active voice detection and microsoft translation service for the translation.
* [Whisper.cpp](https://github.com/ggerganov/whisper.cpp)
* [Microsoft onnx Runtime](https://github.com/microsoft/onnxruntime-swift-package-manager)
* [Silero vad](https://github.com/snakers4/silero-vad)

## How to do contribution to the App?

1. Fork this repo
2. change the value of MICROSOFT_SUBSCRIPTION_KEY in constants.swift to your own key. You may apply it on https://learn.microsoft.com/en-us/azure/ai-services/translator/translator-overview.
3. download the whisper model and silero_vad from the Internet and put it under the VoiceTranslator/Resources/models folder.
4. Run.
