import Foundation

extension Int {
    public mutating func convertToField() -> String {
        if self == 0 {
            return "  "
        } else if self == 1 {
            return "0 "
        } else {
            return "🐙"
        }
    }
}

