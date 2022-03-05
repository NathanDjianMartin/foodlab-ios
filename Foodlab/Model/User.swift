import Foundation

protocol UserObserver {
    
    func changed(name: String)
    func changed(email: String)
    func changed(password: String)
    func changed(isAdmin: Bool)
}

class User: Identifiable, Comparable {
    
    var observer: UserObserver?
    
    var id: Int?
    var name: String {
        didSet {
            self.observer?.changed(name: self.name) // this call makes possible observer to observe
        }
    }
    var email: String {
        // TODO: add verif
        didSet {
            self.observer?.changed(email: self.email) // this call makes possible observer to observe
        }
    }
    var password: String {
        // TODO: add verif
        didSet {
            self.observer?.changed(password: self.password) // this call makes possible observer to observe
        }
    }
    var isAdmin: Bool {
        // TODO: add verif
        didSet {
            self.observer?.changed(password: self.password) // this call makes possible observer to observe
        }
    }
    
    internal init(id: Int? = nil, name: String, email: String, password: String, isAdmin: Bool) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.isAdmin = isAdmin
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: User, rhs: User) -> Bool {
        return lhs.id < rhs.id
    }
    
}
