import XCTest
@testable import OlcRTCClientKit

final class OlcRTCSubscriptionParserTests: XCTestCase {
    private let parser = OlcRTCSubscriptionParser()

    func testParsesRefreshMetadataFromSubscription() throws {
        let sourceURL = URL(string: "https://example.com/sub")!
        let imported = try parser.parse(
            """
            #name: Example
            #update: 1778011200
            #refresh: 10m

            olcrtc://wbstream?datachannel@room-01#d823fa01cb3e0609b67322f7cf984c4ee2e294936fc24ef38c9e59f4799$RU
            ##name: RU-1
            ##ip: 203.0.113.10
            """,
            sourceURL: sourceURL
        )

        XCTAssertEqual(imported.name, "Example")
        XCTAssertEqual(imported.profiles.count, 1)

        let metadata = try XCTUnwrap(imported.profiles.first?.subscription)
        XCTAssertEqual(metadata.sourceURL, sourceURL.absoluteString)
        XCTAssertEqual(metadata.updatedAtUnix, 1_778_011_200)
        XCTAssertEqual(metadata.refreshInterval, "10m")
        XCTAssertNil(metadata.lastFetchedAtUnix)
        XCTAssertEqual(metadata.nodeIP, "203.0.113.10")
    }
}
