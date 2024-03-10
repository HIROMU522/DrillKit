import SwiftUI

struct IntroductionView: View {
    @State private var currentStep = 0
    var moveToMain: () -> Void
    
    var body: some View {
        ZStack {
            Color.yellow.edgesIgnoringSafeArea(.all)
            VStack {
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        FirstView()
                            .frame(width: geometry.size.width)
                        SecondView()
                            .frame(width: geometry.size.width)
                        ThirdView()
                            .frame(width: geometry.size.width)
                    }
                    .offset(x: -CGFloat(currentStep) * geometry.size.width, y: 0)
                    .animation(.easeInOut(duration: 0.3), value: currentStep)
                    .frame(height: geometry.size.height)
                }
                
                Spacer()
                
                HStack {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(index == currentStep ? Color.black : Color.gray)
                            .frame(width: 10, height: 10)
                            .onTapGesture {
                                withAnimation {
                                    currentStep = index
                                }
                            }
                    }
                }
                .padding(.bottom, 20)
                
                Button(action: {
                    withAnimation {
                        if currentStep < 2 {
                            currentStep += 1
                        } else {
                            moveToMain()
                        }
                    }
                }) {
                    Text("Next")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(40)
                }
                .padding(.horizontal, 50)
                
                Spacer()
            }
        }
    }
}

struct FirstView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("Ishikawa")
                .resizable() // サイズ変更を可能にする
                .scaledToFit() // アスペクト比を保持しながらビューにフィットさせる
                .frame(height: 200) // 画像の高さを設定
            Text("Welcome")
                .font(.system(size: 40, weight: .bold)) // タイトルのフォントサイズと太さを設定
            Text("Created from a personal experience of panic during the major earthquake in Ishikawa Prefecture, Japan, on January 1, 2024, this app offers a simulated evacuation drill to guide users on what to do in such emergencies.")
                .font(.system(size: 17, weight: .bold)) // 説明文のフォントサイズと太さを調整
                .padding() // 説明文の周りに余白を追加
                .multilineTextAlignment(.center) // 説明文を中央揃えに
            Spacer()
        }
    }
}



struct SecondView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("HowTo") // 画像を表示
                .resizable()
                .scaledToFit()
                .frame(height: 170)
            
            Text("How To")
                .font(.system(size: 40, weight: .bold))
            Text("DrillKit provides a realistic evacuation drill experience with sounds like alerts, falling shelves, and breaking glass, enabling users to review results and boost disaster preparedness.")
                .font(.system(size: 20, weight: .bold))
                .padding()
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}


struct ThirdView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("Start") // 画像を表示
                .resizable()
                .scaledToFit()
                .frame(height: 170)
            
            Text("Start")
                .font(.system(size: 40, weight: .bold))
            Text("Set up an evacuation drill and get started right away!")
                .font(.system(size: 20, weight: .bold))
                .padding()
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}

