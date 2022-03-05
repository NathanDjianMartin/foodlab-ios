import Foundation

protocol RecipeExecutionObserver {
    func addedStep(_ step: Step)
    func removedStep(at index: Int)
}

class RecipeExecution: Step {
    
    var steps: [Step]
    private var observers: [RecipeExecutionObserver]
    
    override init(id: Int? = nil, title: String) {
        self.steps = []
        self.observers = []
        super.init(id: id, title: title)
    }
    
    func addObserver(_ observer: RecipeExecutionObserver) {
        self.observers.append(observer)
    }
    
    func addStep(_ step: Step) {
        self.steps.append(step)
        for observer in observers {
            observer.addedStep(step)
        }
    }
    
    func removeStep(at index: Int) {
        self.steps.remove(at: index)
        for observer in observers {
            observer.removedStep(at: index)
        }
    }
}


