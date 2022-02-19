import Foundation

protocol AnyStep {
    var title: String { get set }
}

class Step: Identifiable {
    var id: Int?
    var title: String
    
    init(id: Int? = nil, title: String) {
        self.id = id
        self.title = title
    }
}

//typealias Step = AnyStep & Identifiable
