import Foundation

class EvacuationHistory: ObservableObject {
    @Published var records: [EvacuationRecord] = []

    private let userDefaultsKey = "evacuationHistory"

    init() {
        load()
    }

    func save(record: EvacuationRecord) {
        if let index = records.firstIndex(where: { $0.id == record.id }) {
            records[index] = record
        } else {
            records.append(record)
        }
        saveToUserDefaults()
    }

    func deleteRecord(withId id: String) {
        records.removeAll { $0.id == id }
        saveToUserDefaults()
    }

    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }

    private func load() {
        if let savedRecords = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedRecords = try? JSONDecoder().decode([EvacuationRecord].self, from: savedRecords) {
            records = decodedRecords
        }
    }
}



