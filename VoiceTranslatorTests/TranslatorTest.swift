//
//  TranslatorTest.swift
//  SeamlessTalkingTests
//
//  Created by Dustin Li on 2024/3/11.
//

import XCTest
@testable import VoiceTranslator

final class TranslatorTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTranslatorCanTranslateFromEnglishToChinese() throws {
        let translator = OnlineTranslator()
        let request = LanguageAndText("en", "Hello")
        let toLanguage = "zh"
        
        translator.translate(from: request.language, to: toLanguage, text: request.text){ text, error in
            XCTAssertNil(error)
            XCTAssertEqual(text, "你好")
        }
    }

}
