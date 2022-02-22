import Foundation

class RecipeExecution: Step {
    
    var steps: [Step]
    
    override init(id: Int? = nil, title: String) {
        self.steps = []
        super.init(id: id, title: title)
    }
    
    func addStep(_ step: Step) {
        self.steps.append(step)
    }
    
    func removeStep(at index: Int) {
        self.steps.remove(at: index)
    }
}


