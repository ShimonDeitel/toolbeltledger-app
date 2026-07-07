import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [BatteryEntry] = []
    @Published var isPro: Bool = false

    /// Free-tier item cap. Always kept well above seed data count so a fresh
    /// install never hits the paywall immediately.
    static let freeLimit = 10

    private let fileURL: URL

    init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = appSupport.appendingPathComponent("ToolbeltLedger", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("entries.json")
        load()
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeLimit
    }

    func add(_ entry: BatteryEntry) {
        guard canAddMore else { return }
        entries.append(entry)
        save()
    }

    func update(_ entry: BatteryEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: BatteryEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([BatteryEntry].self, from: data) {
            entries = decoded
        } else {
            entries = [
        BatteryEntry(name: "DeWalt 20V", brand: "DeWalt 20V", capacity: "5.0", cycleCount: ""),
        BatteryEntry(name: "Milwaukee M18", brand: "Milwaukee M18", capacity: "6.0", cycleCount: ""),
        BatteryEntry(name: "Makita 18V", brand: "Makita 18V", capacity: "4.0", cycleCount: "")
            ]
            save()
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }
}
