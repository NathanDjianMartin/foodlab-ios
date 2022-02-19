import Foundation

class SimpleStep: Step {
    
    var description: String
    var duration: Int
    
    init(id: Int? = nil, title: String, stepDescription: String, duration: Int) {
        self.description = stepDescription
        self.duration = duration
        super.init(id: id, title: title)
    }
}
