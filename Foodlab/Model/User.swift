import Foundation

class User: Identifiable {
    
    var id: Int?
    var name: String
    var email: String
    var password: String
    var isAdmin: Bool
    
    internal init(id: Int? = nil, name: String, email: String, password: String, isAdmin: Bool) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.isAdmin = isAdmin
    }
    
}
