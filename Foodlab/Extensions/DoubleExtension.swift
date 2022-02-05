import Foundation

extension Double {
    
    func roundTo(_ decimals: Int) -> String {
        return String(format: "%.\(decimals)f", self)
    }
}
