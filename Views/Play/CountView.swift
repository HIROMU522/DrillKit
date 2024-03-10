import SwiftUI

struct CountView: View {
    @State private var timeRemaining = 5
    @State private var showWarningScreen = true
    @State private var timer: Timer?
    var moveToEvacuation: () -> Void

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            if showWarningScreen {
                VStack {
                    // 警告文を上部に配置
                    Text("Please do not sound the alarm in places where there are unspecified numbers of people.")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .padding(.top, 50) // 上部に余白を追加

                    Spacer() // このSpacerが上部のテキストと中央のテキストの間にスペースを作る
                    
                    // "Tap to Start"を中央に配置
                    Text("Tap to Start")
                        .font(.system(size: 50, weight: .bold, design: .default))
                        .foregroundColor(.white)
                    Spacer() // このSpacerが下部を調整する
                }
                .onTapGesture {
                    self.showWarningScreen = false
                    startTimer()
                }
            } else {
                // カウンタ画面
                VStack {
                    Text("\(timeRemaining)")
                        .font(.system(size: 150, weight: .bold, design: .default))
                        .foregroundColor(.yellow)
                }
            }
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }

            if self.timeRemaining == 0 {
                self.timer?.invalidate()
                self.timer = nil
                self.moveToEvacuation()
            }
        }
    }
}

