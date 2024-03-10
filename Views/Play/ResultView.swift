import SwiftUI
import Foundation


extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct EvacuationRecord: Codable, Identifiable {
    var id: String = UUID().uuidString
    let minutes: Int
    let seconds: Int
    let freeText: String
    let date: Date
    let numberOfPeople: String // 人数を保持する新しいフィールド
    let selectedCategory: String // カテゴリを保持する新しいフィールド
}


struct ResultView: View {
    let minutes: Int
    let seconds: Int
    var moveToMain: () -> Void
    
    private var numberOfPeople: String {
        UserDefaults.standard.string(forKey: "numberOfPeople") ?? "Not Set"
    }
    
    private var selectedCategory: String {
        UserDefaults.standard.string(forKey: "selectedCategory") ?? "Not Set"
    }
    
    @State private var freeText: String = ""
    
    init(minutes: Int, seconds: Int, moveToMain: @escaping () -> Void) {
        self.minutes = minutes
        self.seconds = seconds
        self.moveToMain = moveToMain
    }
    
    var body: some View {
        VStack {
            Text("Well Done!")
                .padding()
                .foregroundColor(.black)
                .font(.system(size: 60, weight: .bold))
            
            Image(systemName: "figure.walk")
                .font(.largeTitle)
                .padding(.bottom)
                .foregroundColor(.black)
            
            Text("Time taken to evacuate")
                .font(.headline)
                .foregroundColor(.black)
            
            Text("\(minutes):\(String(format: "%02d", seconds))")
                .font(.system(size: 40, weight: .bold)) 
                .padding(.vertical)
                .foregroundColor(.black)
            
            Group {
                Text("Number of People: \(numberOfPeople)")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                Text("Selected Category: \(selectedCategory)")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            .padding(.vertical, 1)
            
            TextEditor(text: $freeText)
                .frame(height: 150) // 縦のサイズを拡大
                .border(Color.black, width: 5)
                .cornerRadius(20)
                .padding(.horizontal)
                

            Button("TOP") {
                let newRecord = EvacuationRecord(
                    minutes: minutes,
                    seconds: seconds,
                    freeText: freeText,
                    date: Date(),
                    numberOfPeople: numberOfPeople,
                    selectedCategory: selectedCategory
                )
                let history = EvacuationHistory()
                history.save(record: newRecord)
                moveToMain()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom)
        }
        .onAppear {
            freeText = ""
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow) // 背景色を黄色に変更
        .onTapGesture {
            UIApplication.shared.closeKeyboard()
        }
        .navigationBarHidden(true)
    }
}


struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        // ResultViewに必要なパラメータを適切に設定してください。
        ResultView(minutes: 1, seconds: 30) {
            // ここにResultViewからメインビューに戻るためのアクションを記述します。
            // プレビューの目的では、具体的な実装は不要です。
        }
    }
}
