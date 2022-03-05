import Foundation

protocol RecipeExecutionObserver {
    func addedStep(_ step: Step)
    func removedStep(at offSets: IndexSet)
    func moved(source: IndexSet, destination: Int)
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
    
//    func removeStep(at index: Int) {
//        self.steps.remove(at: index)
//        for observer in observers {
//            observer.removedStep(at: index)
//        }
//    }
    
    func removeStep(atOffsets offsets: IndexSet) {
        self.steps.remove(atOffsets: offsets)
        for observer in observers {
            observer.removedStep(at: offsets)
        }
    }
    
    func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        self.steps.move(fromOffsets: source, toOffset: destination)
        for observer in observers {
            observer.moved(source: source, destination: destination)
        }
    }
}


