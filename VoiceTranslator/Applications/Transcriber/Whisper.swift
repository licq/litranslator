import Foundation
import whisper
import OpenCC

// Meet Whisper C++ constraint: Don't access from more than one thread at a time.
public class WhisperContext {
    enum WhisperError: Error{
        case modelFileNotFound
        case couldNotInitializeContext
        
        var message: String{
            switch self{
            case .modelFileNotFound: return "can't find model file models/ggml-small.bin"
            case .couldNotInitializeContext: return "could not initilize context"
            }
        }
    }
    
    private var context: OpaquePointer
    
    init(context: OpaquePointer){
        self.context = context
    }
    
    deinit {
        whisper_free(context)
        print("deinit whisper")
    }
    
    func fullTranscribe(samples: [Float]) -> LanguageAndText{
        var params = whisper_full_default_params(WHISPER_SAMPLING_GREEDY)
        let prompt = "Use capital letters and punctuation. Do not repeat yourself. Do not describe ambient sounds or noise or silence, just ommit. Break the text into sentences."
        
        "auto".withCString { language in
            prompt.withCString{ prompt in
                params.print_realtime   = true
                params.language         = language
                params.n_threads        = threadCount
                params.initial_prompt = prompt
                
                whisper_reset_timings(context)
                print("About to run whisper_full with \(samples.count) data")
                samples.withUnsafeBufferPointer { samples in
                    if (whisper_full(context, params, samples.baseAddress, Int32(samples.count)) != 0) {
                        print("Failed to run the model")
                    } else {
                        whisper_print_timings(context)
                    }
                }
            }
        }
        
        let language = getLanguage()
        var transcription = getTranscription()
        if Language.isChinese(language){
            do{
                transcription = try OpenCC.ChineseConverter(options: .simplify).convert(transcription)
            }catch{
                print("convert failed \(error)")
            }
        }
        return LanguageAndText(language, transcription)
    }
    
    func fullTranscribeWithLanguage(_ samples: [Float], language: String) -> String{
        var params = whisper_full_default_params(WHISPER_SAMPLING_GREEDY)
        print("About to run whisper_full with language \(language)")
        var prompt = "Use capital letters and punctuation. Do not repeat yourself. Do not describe ambient sounds or noise or silence, just ommit. Break the text into sentences."
        if language == "zh"{
            prompt = "使用标点符号。不要重复自己的话。不要描述周围的声音、噪音或沉默，直接省略掉。将长文本分成语句。"
        }
        language.withCString { language in
            prompt.withCString{ prompt in
                params.print_realtime = false
                params.language = language
                params.n_threads = threadCount
                params.print_progress = false
                //                params.initial_prompt =  prompt
                
                whisper_reset_timings(context)
                
                samples.withUnsafeBufferPointer { samples in
                    if (whisper_full(context, params, samples.baseAddress, Int32(samples.count)) != 0) {
                        print("Failed to run the model")
                    } else {
                        whisper_print_timings(context)
                    }
                }
            }
        }
        return getTranscription()
    }
    
    func detectLanguage(_ samples: [Float]) -> String{
        var params = whisper_full_default_params(WHISPER_SAMPLING_GREEDY)
        params.print_progress = false
        params.detect_language = true
        params.print_realtime = false
        params.n_threads = threadCount
        
        whisper_reset_timings(context)
        print("About to run whisper detect language")
        samples.withUnsafeBufferPointer { samples in
            if (whisper_full(context, params, samples.baseAddress, Int32(samples.count)) != 0) {
                print("Failed to run the model")
            } else {
                whisper_print_timings(context)
            }
        }
        
        return getLanguage()
    }
    
    private func getTranscription() -> String {
        var transcription = ""
        for i in 0..<whisper_full_n_segments(context) {
            transcription += String.init(cString: whisper_full_get_segment_text(context, i))
        }
        return transcription
    }
    
    private func getLanguage() -> String{
        let id = whisper_full_lang_id(context)
        guard let language = whisper_lang_str(id) else { return "unknown" }
        return String.init(cString: language)
    }
    
    static func createContext() throws -> WhisperContext {
        let modelUrl = Bundle.main.url(forResource: "ggml-small", withExtension: "bin", subdirectory: "models")
        guard let modelUrl = modelUrl else{
            throw WhisperError.modelFileNotFound
        }
        
        var params = whisper_context_default_params()
#if targetEnvironment(simulator)
        params.use_gpu = false
        print("Running on the simulator, using CPU")
#endif
        let context = whisper_init_from_file_with_params(modelUrl.path(), params)
        if let context {
            return WhisperContext(context: context)
        } else {
            print("Couldn't load model at \(modelUrl)")
            throw WhisperError.couldNotInitializeContext
        }
    }
    
    private var threadCount: Int32{
        let cpuCount = ProcessInfo.processInfo.processorCount
        return Int32(max(1, min(8, cpuCount - 2)))
    }
}

