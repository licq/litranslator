//
//  ApplicationTest.swift
//  SeamlessTalkingTests
//
//  Created by Dustin Li on 2024/3/11.
//

import XCTest
@testable import VoiceTranslator

final class TranscriberTest: XCTestCase {

    private var transcriber: Transcriber?
    
    override func setUpWithError() throws {
        transcriber = Transcriber()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAfterProcessCanRemoveSquare() throws {
        let text = "[Clear throat]"
        let afterProcess = transcriber!.postProcess(text)
        XCTAssert(afterProcess.isEmpty)
    }
    
    func testAfterProcessCanRemoveComma() throws{
        let text = "hello,beijing(Clear throat)"
        let afterProcess = transcriber!.postProcess(text)
        XCTAssertEqual("hello,beijing", afterProcess)
    }

}
