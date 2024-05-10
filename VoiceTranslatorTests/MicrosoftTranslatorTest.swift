import XCTest
@testable import VoiceTranslator

class MicrosoftTranslatorTests: XCTestCase {

    var microsoftTranslator: MicrosoftTranslator!

    override func setUp() {
        super.setUp()
        let profile = Profile.shared
        microsoftTranslator = MicrosoftTranslator(endpoint: profile.selectedEndpoint, region: profile.selectedRegion, key: profile.selectedKey)
    }

    override func tearDown() {
        microsoftTranslator = nil
        super.tearDown()
    }

    func testTranslate() {
        let expectation = self.expectation(description: "Translation is completed")
        
        microsoftTranslator.translate(from: "en", to: "zh", text: "Hello, World!") { (translatedText, error) in
            XCTAssertNil(error, "There was an error: \(error!.localizedDescription)")
            XCTAssertNotNil(translatedText, "Translated text should not be nil")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
