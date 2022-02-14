import Foundation
import SwiftUI

struct IsAuthenticatedKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var isAuthenticated: Bool {
        get {
            self[IsAuthenticatedKey.self]
        }
        set {
            self[IsAuthenticatedKey.self] = newValue
        }
    }
}
