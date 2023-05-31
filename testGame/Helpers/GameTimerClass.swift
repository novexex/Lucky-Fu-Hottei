
import Foundation

class GameTimer {
    var time: String {
        return formatTimeInterval(timePlayedInSeconds)
    }
    
    var timePlayedInSeconds: TimeInterval = 0
    private var timer: Timer?
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timePlayedInSeconds += 1
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        timePlayedInSeconds = 0
    }
}
