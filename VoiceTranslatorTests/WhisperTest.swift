//
//  WhisperTest.swift
//  SeamlessTalkingTests
//
//  Created by Dustin Li on 2024/3/10.
//

import XCTest
@testable import VoiceTranslator


final class WhisperTest: XCTestCase {

    private var whisperContext: WhisperContext?
    private var samples: [Float]?
    
    override func setUpWithError() throws {
        try whisperContext = WhisperContext.createContext()
        try samples = decodeWaveFile()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testFullTranscribePerformance() throws {
        self.measure {
            let _ = whisperContext?.fullTranscribe(samples: samples!)
        }
    }
    
    func testFullTranscribeWithLanguagePerformance() throws {
        self.measure {
            let _ = whisperContext?.fullTranscribeWithLanguage(samples!, language: "en")
        }
    }
    
    func testDetectLanguagePerformance() throws {
        self.measure {
            let _ = whisperContext?.detectLanguage(samples!)
        }
    }
    
    func decodeWaveFile() throws -> [Float] {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: "jfk", withExtension: "wav", subdirectory: "samples")!
        let data = try Data(contentsOf: url)
        let floats = stride(from: 44, to: data.count, by: 2).map {
            return data[$0..<$0 + 2].withUnsafeBytes {
                let short = Int16(littleEndian: $0.load(as: Int16.self))
                return max(-1.0, min(Float(short) / 32767.0, 1.0))
            }
        }
        return floats
    }


}
