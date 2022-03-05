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
    
    func predicate(i: Int) throws -> Bool {
        return i < self.steps.count
    }
    
    func removeStep(atOffsets offsets: IndexSet) {
        do {
            guard try offsets.allSatisfy(predicate(i:)) else {
                return
            }
            self.steps.remove(atOffsets: offsets)
            for observer in observers {
                observer.removedStep(at: offsets)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        guard destination < self.steps.count else {
            return
        }
        self.steps.move(fromOffsets: source, toOffset: destination)
        for observer in observers {
            observer.moved(source: source, destination: destination)
        }
    }
}


