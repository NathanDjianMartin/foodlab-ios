import Foundation

extension Double {
    
    func roundTo(decimals: Int) -> String {
        return String(format: "%.\(decimals)f", self)
    }
}
