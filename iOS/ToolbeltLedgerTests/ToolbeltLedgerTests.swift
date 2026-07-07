import XCTest
@testable import ToolbeltLedger

@MainActor
final class ToolbeltLedgerTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.entries = []
    }

    func testAddEntry() {
        let entry = BatteryEntry(name: "Test", brand: "A", capacity: "B", cycleCount: "")
        store.add(entry)
        XCTAssertEqual(store.entries.count, 1)
    }

    func testDeleteEntry() {
        let entry = BatteryEntry(name: "Test", brand: "A", capacity: "B", cycleCount: "")
        store.add(entry)
        store.delete(entry)
        XCTAssertTrue(store.entries.isEmpty)
    }

    func testUpdateEntry() {
        var entry = BatteryEntry(name: "Test", brand: "A", capacity: "B", cycleCount: "")
        store.add(entry)
        entry.name = "Updated"
        store.update(entry)
        XCTAssertEqual(store.entries.first?.name, "Updated")
    }

    func testFreeLimitEnforced() {
        for i in 0..<Store.freeLimit {
            store.add(BatteryEntry(name: "Item \(i)", brand: "", capacity: "", cycleCount: ""))
        }
        XCTAssertEqual(store.entries.count, Store.freeLimit)
        XCTAssertFalse(store.canAddMore)
        store.add(BatteryEntry(name: "Overflow", brand: "", capacity: "", cycleCount: ""))
        XCTAssertEqual(store.entries.count, Store.freeLimit)
    }

    func testProUnlocksUnlimited() {
        store.isPro = true
        for i in 0..<(Store.freeLimit + 5) {
            store.add(BatteryEntry(name: "Item \(i)", brand: "", capacity: "", cycleCount: ""))
        }
        XCTAssertEqual(store.entries.count, Store.freeLimit + 5)
    }

    func testSeedDataBelowFreeLimit() {
        let fresh = Store()
        XCTAssertLessThan(fresh.entries.count, Store.freeLimit)
    }

    func testDeleteAtOffsets() {
        store.add(BatteryEntry(name: "A", brand: "", capacity: "", cycleCount: ""))
        store.add(BatteryEntry(name: "B", brand: "", capacity: "", cycleCount: ""))
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.entries.count, 1)
        XCTAssertEqual(store.entries.first?.name, "B")
    }

    func testCanAddMoreInitiallyTrue() {
        XCTAssertTrue(store.canAddMore)
    }
}
