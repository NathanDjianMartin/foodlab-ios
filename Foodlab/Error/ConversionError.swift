import Foundation

enum ConversionError: Error, CustomStringConvertible {
    case stringToDouble
    
    public var description: String {
        switch self {
        case .stringToDouble:
            return "Error while cast string to double"
        }
    }
}
