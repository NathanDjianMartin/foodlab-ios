import Foundation

class Category: Identifiable, Hashable {
    
    var id: Int?
    var name: String
    //TODO: Peut être une enum pour savoir de quelle category il s'agit
    
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
