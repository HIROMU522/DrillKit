import SwiftUI

struct MainView: View {
    var moveToCount: () -> Void
    var moveToSetting: () -> Void
    var moveToHistory: () -> Void
    
    var body: some View {
        ZStack {
            Color.yellow.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                VStack {
                    Image("Alert")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                    
                    Text("Drill Kit")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 40)
                        .foregroundColor(Color.black)
                }
                
                HStack {
                    Spacer() // 左のスペース
                    
                    // スタートボタン
                    Button(action: moveToSetting) {
                        VStack {
                            Image(systemName: "gearshape")
                                .font(.system(size: 70))
                                .foregroundColor(.black)
                            Text("Settings")
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    
                    Spacer() // 中央のスペース
                    
                    // 設定ボタン
                    Button(action: moveToCount) {
                        VStack {
                            Image(systemName: "play.circle")
                                .font(.system(size: 70))
                                .foregroundColor(.black)
                            Text("Start")
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    
                    Spacer() // 中央のスペース
                    
                    // 履歴ボタン
                    Button(action: moveToHistory) {
                        VStack {
                            Image(systemName: "clock")
                                .font(.system(size: 70))
                                .foregroundColor(.black)
                            Text("History")
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    
                    Spacer() // 右のスペース
                }
            }
        }
    }
}

