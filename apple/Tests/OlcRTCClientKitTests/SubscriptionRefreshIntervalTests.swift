import XCTest
@testable import OlcRTCClientKit

final class SubscriptionRefreshIntervalTests: XCTestCase {
    func testParsesDocumentedRefreshIntervals() {
        XCTAssertEqual(SubscriptionRefreshInterval.seconds(from: "5s"), 5)
        XCTAssertEqual(SubscriptionRefreshInterval.seconds(from: "10m"), 600)
        XCTAssertEqual(SubscriptionRefreshInterval.seconds(from: "6h"), 21_600)
        XCTAssertEqual(SubscriptionRefreshInterval.seconds(from: "1d"), 86_400)
    }

    func testTrimsWhitespaceAndAcceptsUppercaseUnits() {
        XCTAssertEqual(SubscriptionRefreshInterval.seconds(from: " 2 H "), 7_200)
    }

    func testRejectsInvalidIntervals() {
        XCTAssertNil(SubscriptionRefreshInterval.seconds(from: nil))
        XCTAssertNil(SubscriptionRefreshInterval.seconds(from: ""))
        XCTAssertNil(SubscriptionRefreshInterval.seconds(from: "10"))
        XCTAssertNil(SubscriptionRefreshInterval.seconds(from: "0s"))
        XCTAssertNil(SubscriptionRefreshInterval.seconds(from: "10ms"))
    }
}
