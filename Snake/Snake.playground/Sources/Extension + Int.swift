import Foundation


extension Int {
    public mutating func convertToField() -> String {
        if self == 0 {
            return "🌫"
        } else if self == 1 {
            return "🌳"
        } else if self == 8 {
            return "🍎"
        } else if self == 7 {
            return "🐍"
        } else if self == 10 {
            return "🏁"
        } else {
            return "💎"
        }
    }
}
