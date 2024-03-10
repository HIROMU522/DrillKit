import SwiftUI
import AVFoundation
import AudioToolbox


struct EvacuationView: View {
    @ObservedObject var viewModel: TimerViewModel
    var moveToResult: ((Int, Int) -> Void)?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var secondsElapsed = 0
    @State private var timerIsActive = false
    @State private var showAlert = false
    @State private var totalSeconds = 0
    @State private var fadeInOut = false // アニメーションの初期状態をfalseに設定
    @State private var isMuted = false // ミュート状態を制御するための状態変数を追加
    var moveToMain: () -> Void
    // UserDefaultsから振動設定を読み込む
    let isVibrationEnabled = UserDefaults.standard.bool(forKey: "isVibrationEnabled")
    @State private var isPressing = false // 長押し中かどうかを追跡する状態
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.yellow.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer().frame(height: 40)
                    
                    Text("ESCAPE")
                        .font(.system(size: 70, weight: .black))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.top, 20)
                    // secondsElapsedに応じて点滅制御
                        .opacity(secondsElapsed <= 60 ? (fadeInOut ? 1 : 0) : 1)
                    
                    Spacer()
                    
                    Text(timeString(from: secondsElapsed))
                        .font(.system(size: 72, weight: .bold))
                        .foregroundColor(.black)
                        .padding()
                    
                    Spacer()
                    
                    HStack(spacing: 40) {
                        Button(action: {
                            timerIsActive.toggle()
                            if timerIsActive {
                                audioPlayer?.play()
                            } else {
                                audioPlayer?.pause()
                            }
                        }) {
                            Image(systemName: timerIsActive ? "pause.circle.fill" : "play.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        
                        // Reset Button with Long Press Gesture
                        if !timerIsActive {
                            Image(systemName: "stop.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .scaleEffect(isPressing ? 1.1 : 1.0) // 長押しで拡大
                                .animation(.easeInOut(duration: 0.2), value: isPressing)
                                .gesture(
                                    LongPressGesture(minimumDuration: 1)
                                        .onChanged { _ in
                                            isPressing = true // 長押し開始時にフラグを立てる
                                        }
                                        .onEnded { _ in
                                            isPressing = false // 長押し終了時にフラグを下ろす
                                            // ここで画面を振動させる
                                            let generator = UIImpactFeedbackGenerator(style: .medium)
                                            generator.impactOccurred()
                                            moveToMain() // 長押し終了時に関数を実行
                                        }
                                )
                        }
                        
                    }
                    
                    
                    Spacer()
                    
                    Button(action: {
                        self.timerIsActive = false
                        self.totalSeconds = self.secondsElapsed
                        showAlert = true
                    }) {
                        Text("Finish")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 200, height: 200)
                            .background(Color.black)
                            .clipShape(Circle())
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Confirmation"),
                            message: Text("Are you sure you want to finish?"),
                            primaryButton: .destructive(Text("Yes")) {
                                let minutes = totalSeconds / 60
                                let seconds = totalSeconds % 60
                                moveToResult?(minutes, seconds)
                            },
                            secondaryButton: .cancel(Text("No"))
                        )
                    }
                }
                .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                    if timerIsActive {
                        secondsElapsed += 1
                        if secondsElapsed <= 60 {
                            withAnimation(Animation.linear(duration: 0.5).repeatForever(autoreverses: true)) {
                                fadeInOut.toggle()
                            }
                        }
                        if isVibrationEnabled {
                            if secondsElapsed <= 15 {
                                // タイマーが15秒以下の場合、警告振動を発生させる
                                AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
                            } else if secondsElapsed <= 100 {
                                // タイマーが15秒以上200秒以下の場合、より強い振動を発生させる
                                AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(1521)) {}
                            }
                        }
                    }
                }
                
                .onAppear {
                    // UserDefaultsから警報音の設定を読み込み、その値に基づいてミュート状態を設定
                    let alarmEnabled = UserDefaults.standard.bool(forKey: "isAlarmEnabled")
                    isMuted = !alarmEnabled // 警報音がオフの場合、isMutedをtrueに設定
                    
                    // タイマーをアクティブ状態に設定
                    timerIsActive = true
                    
                    // 警報音の設定が有効な場合、バックグラウンドミュージックを再生
                    if alarmEnabled {
                        playBackgroundMusic()
                    }
                }
                .toolbar {
                    // ナビゲーションバーにミュートボタンを追加
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isMuted.toggle() // ミュート状態をトグル
                            updateAudioPlayerVolume() // 音量を更新
                        }) {
                            Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                        }
                    }
                }
            }
        }
    }
    
    func timeString(from totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func playBackgroundMusic(startingFrom elapsedTime: TimeInterval = 0) {
        guard let asset = NSDataAsset(name: "EmergencySound") else {
            print("音声ファイルが見つかりません。")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(data: asset.data)
            audioPlayer?.volume = isMuted ? 0 : 0.5 // ミュート状態に応じて音量を設定
            audioPlayer?.numberOfLoops = 0 
            
            // 音楽ファイルの長さを取得し、経過時間に応じて再生位置を設定
            let musicDuration = audioPlayer?.duration ?? 0
            let startPosition = elapsedTime.truncatingRemainder(dividingBy: musicDuration)
            audioPlayer?.currentTime = startPosition
            
            audioPlayer?.play()
        } catch {
            print("音声の再生に失敗しました: \(error.localizedDescription)")
        }
    }
    
    
    // 音量を更新する関数
    private func updateAudioPlayerVolume() {
        if isMuted {
            audioPlayer?.volume = 0 // ミュート状態の場合、音量を0に設定
        } else {
            if audioPlayer == nil {
                playBackgroundMusic(startingFrom: Double(secondsElapsed)) // 音を途中から再生
            } else {
                audioPlayer?.volume = 0.5 // ミュートでない場合、音量を0.5に設定
            }
        }
    }
    
    
}


