
import Foundation

func formatTimeInterval(_ timeInterval: TimeInterval) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.minute, .second]
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = .pad
    
    return formatter.string(from: timeInterval) ?? "00:00"
}
