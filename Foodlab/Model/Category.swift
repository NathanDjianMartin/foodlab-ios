import Foundation

class Category: Identifiable {
    
    var id: Int?
    var name: String
    //TODO: Peut être une enum pour savoir de quelle category il s'agit
    
    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
