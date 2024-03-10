import SwiftUI

struct RecordDetailView: View {
    @EnvironmentObject var history: EvacuationHistory
    @State private var showingDeleteAlert = false
    @State private var isEditing = false
    @State private var editableRecord: EditableEvacuationRecord
    private let categories = ["Family", "Personal", "Company", "Other"]

    
    let record: EvacuationRecord
    
    init(record: EvacuationRecord) {
        self.record = record
        self._editableRecord = State(initialValue: EditableEvacuationRecord(from: record))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                HStack {
                    Image(systemName: "clock.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                    
                    
                    Text("\(record.minutes):\(String(format: "%02d", record.seconds))")
                        .font(.system(size: 50))
                    
                }
                .padding(.vertical)
                
                // 人数の表示と編集
                   if isEditing {
                       TextField("Number of People", text: $editableRecord.numberOfPeople)
                           .textFieldStyle(RoundedBorderTextFieldStyle())
                   } else {
                       Text("Number of People: \(record.numberOfPeople)")
                           .font(.headline)
                   }

                if isEditing {
                    Picker("Category", selection: $editableRecord.selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                } else {
                    Text("Selected Category: \(record.selectedCategory)")
                        .font(.headline)
                }

                
                
                if isEditing {
                    TextField("Notes", text: $editableRecord.freeText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    Text("Notes")
                        .font(.headline)
                        .padding(.top)
                    
                    TextEditor(text: .constant(record.freeText))
                        .frame(height: 100)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .disabled(true)
                }
                
                Button(isEditing ? "Save" : "Edit") {
                    if isEditing {
                        // Save the edited record
                        let updatedRecord = EvacuationRecord(
                            id: record.id,
                            minutes: editableRecord.minutes,
                            seconds: editableRecord.seconds, 
                            freeText: editableRecord.freeText,
                            date: record.date,
                            numberOfPeople: editableRecord.numberOfPeople, // 人数を更新
                            selectedCategory: editableRecord.selectedCategory // カテゴリを更新
                        )
                        history.save(record: updatedRecord)
                    }

                    isEditing.toggle()
                }
                .padding()
                .background(isEditing ? Color.green : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                if !isEditing {
                    Button("Delete Record") {
                        showingDeleteAlert = true
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
                    .alert(isPresented: $showingDeleteAlert) {
                        Alert(
                            title: Text("Confirm"),
                            message: Text("Do you really want to delete this record?"),
                            primaryButton: .destructive(Text("Delete")) {
                                history.deleteRecord(withId: record.id)
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            .padding()
        }
        .navigationBarTitle("Evacuation Detail", displayMode: .inline)
    }
    
}

// EditableEvacuationRecord struct definition
struct EditableEvacuationRecord {
    var id: String
    var minutes: Int
    var seconds: Int
    var freeText: String
    var date: Date
    var numberOfPeople: String // 新しいフィールド
    var selectedCategory: String // 新しいフィールド
    
    init(from record: EvacuationRecord) {
        self.id = record.id
        self.minutes = record.minutes
        self.seconds = record.seconds
        self.freeText = record.freeText
        self.date = record.date
        self.numberOfPeople = record.numberOfPeople // 初期化時に値を設定
        self.selectedCategory = record.selectedCategory // 初期化時に値を設定
    }
}


