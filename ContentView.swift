import SwiftUI

struct ContentView: View {
    @State private var currentScreen: Screen = .main
    @State private var resultMinutes: Int = 0
    @State private var resultSeconds: Int = 0
    @State private var isFirstLaunch: Bool = UserDefaults.standard.bool(forKey: "isFirstLaunch")
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                switch currentScreen {
                case .introduction:
                    IntroductionView(moveToMain: {
                        self.currentScreen = .main
                        UserDefaults.standard.set(false, forKey: "isFirstLaunch")
                    })
                case .main:
                    MainView(moveToCount: {
                        self.currentScreen = .count
                    }, moveToSetting: {
                        self.currentScreen = .setting
                    }, moveToHistory: {
                        self.currentScreen = .history
                    })
                case .count:
                    CountView(moveToEvacuation: {
                        self.currentScreen = .evacuation
                    })
                case .setting:
                    SettingView(moveToMain: {
                        self.currentScreen = .main
                    })
                case .history:
                    HistoryView(moveToMain: {
                        self.currentScreen = .main
                    })
                case .evacuation:
                    EvacuationView(viewModel: TimerViewModel(), moveToResult: { minutes, seconds in
                        self.resultMinutes = minutes
                        self.resultSeconds = seconds
                        self.currentScreen = .result
                    }, moveToMain: {
                        self.currentScreen = .main
                    })
                case .result:
                    ResultView(minutes: resultMinutes, seconds: resultSeconds, moveToMain: {
                        self.currentScreen = .main
                    })


                }
            }
            .onAppear {
                if LaunchUtil.launchStatus == .firstLaunch {
                    currentScreen = .introduction
                } else {
                    currentScreen = .main
                }
            }        }
    }
}

enum Screen {
    case introduction
    case main
    case count
    case setting
    case history
    case evacuation
    case result
}

