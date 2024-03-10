import SwiftUI

struct HistoryView: View {
    @ObservedObject var history = EvacuationHistory()
    var moveToMain: () -> Void

    var body: some View {
        NavigationView {
            Group {
                if history.records.isEmpty {
                    // 履歴がない場合のビュー
                    Text("Let's try an evacuation drill")
                        .font(.title)
                        .foregroundColor(.gray)
                        .centered() // 拡張メソッドで中央寄せを行う
                } else {
                    // 履歴がある場合のリストビュー
                    List(history.records.sorted(by: { $0.date > $1.date })) { record in
                        NavigationLink(destination: RecordDetailView(record: record).environmentObject(history)) {
                            VStack(alignment: .leading) {
                                Text("\(record.date, formatter: dateFormatter)")
                                Text("\(record.minutes):\(String(format: "%02d", record.seconds))")
                                Text("Category: \(record.selectedCategory)")
                            }
                        }
                    }

                }
            }
            .navigationBarTitle("Evacuation History")
            .navigationBarItems(trailing: Button("Done") {
                moveToMain()
            })
        }
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

extension View {
    func centered() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                self
                Spacer()
            }
            Spacer()
        }
    }
}


