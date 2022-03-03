import Foundation

enum JSONError: LocalizedError {
    case decode
    case encode
    
    var description: String {
        switch self {
        case .decode:
            return "Error while decoding data"
        case .encode:
            return "Error while encoding object in data"
        }
    }
    
    var errorDescription: String? {
        return self.description
    }
}
