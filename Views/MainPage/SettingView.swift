import SwiftUI

struct SettingView: View {
    @State private var isAlarmEnabled: Bool = UserDefaults.standard.bool(forKey: "isAlarmEnabled")
    @State private var numberOfPeople: String = UserDefaults.standard.string(forKey: "numberOfPeople") ?? ""
    @State private var selectedCategory: String = UserDefaults.standard.string(forKey: "selectedCategory") ?? "Family"
    @State private var isVibrationEnabled: Bool = UserDefaults.standard.bool(forKey: "isVibrationEnabled")

    
    private let categories = ["Family", "Personal", "Company", "Other"]
    
    var moveToMain: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("General").font(.headline)) {
                    Toggle(isOn: $isAlarmEnabled) {
                        HStack {
                            Image(systemName: "bell.fill") // アラームアイコン
                                .foregroundColor(.blue)
                            Text("Alarm Sound")
                        }
                    }
                    .onChange(of: isAlarmEnabled) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "isAlarmEnabled")
                    }
                    
                    // List内に振動設定のToggleを追加
                    Toggle(isOn: $isVibrationEnabled) {
                        HStack {
                            Image(systemName: "iphone.radiowaves.left.and.right") // 振動アイコン
                                .foregroundColor(.orange)
                            Text("Vibration")
                        }
                    }
                    .onChange(of: isVibrationEnabled) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "isVibrationEnabled")
                    }
                    
                    HStack {
                        Image(systemName: "person.3.fill") // 人数アイコン
                            .foregroundColor(.green)
                        TextField("Number of People", text: $numberOfPeople)
                            .keyboardType(.numberPad)
                    }
                    .onChange(of: numberOfPeople) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "numberOfPeople")
                    }
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedCategory) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "selectedCategory")
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationBarTitle("Settings", displayMode: .large)
            .navigationBarItems(trailing: Button("Done") {
                moveToMain()
            })
        }
        .hideKeyboardOnTap() // ここで修飾子を適用します
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(moveToMain: {})
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
#endif

