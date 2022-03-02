import Foundation

enum URLError: Error, CustomStringConvertible {
    case failedInit
    
    public var description: String {
        switch self {
        case .failedInit:
            return "Error while creating url from string"
        }
    }
}
