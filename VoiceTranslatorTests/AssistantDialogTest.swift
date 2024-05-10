//
//  AssistantDialogTest.swift
//  SeamlessTalkingTests
//
//  Created by Chaoqun Li on 2024/3/25.
//

import XCTest
@testable import VoiceTranslator

final class AssistantDialogTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCanConverttoJson() throws {
        let assistantDialog = AssistantDialog()
        assistantDialog.append(AssistantMessage(content: "你的名字叫什么？", role: .user))
        assistantDialog.append(AssistantMessage(content: "Dustin", role: .assistant))
        
        let json = try JSONEncoder().encode(assistantDialog.messages)
        print(String(data: json, encoding: .utf8))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
