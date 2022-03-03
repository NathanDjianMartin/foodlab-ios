import Foundation

protocol CategoryObserver {
    func changed(name: String)
}

class Category: Identifiable, Hashable {
    
    var observer: CategoryObserver?
    
    var id: Int?
    var name: String {
        didSet { // if name was set, we should warn our observer
            if name.count <= 0 {
                name = oldValue
            } else {
                self.observer?.changed(name: self.name) // this call makes possible observer to observe
            }
        }
    }
    
    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
    
    static func ==(lsh: Category, rhs: Category) -> Bool {
        return lsh.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
