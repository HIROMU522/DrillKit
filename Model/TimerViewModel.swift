import Foundation

class TimerViewModel: ObservableObject {
    @Published var isActive = false

    func stopTimer() {
        isActive = false
    }
    
    
}
