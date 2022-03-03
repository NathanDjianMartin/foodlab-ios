import Foundation

enum HttpError: Error {
    case error(Int)
    case conflict(String)
}
