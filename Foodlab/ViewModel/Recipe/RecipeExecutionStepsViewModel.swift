import Foundation
import Combine

class RecipeExecutionStepsViewModel: ObservableObject, Subscriber, RecipeExecutionObserver {
    
    private (set) var model: RecipeExecution
    @Published var steps: [Step]
    
    init(model: RecipeExecution) {
        self.model = model
        self.steps = model.steps
        self.model.addObserver(self)
    }
    
    // MARK: -
    // MARK: RecipeExecutionObserver conformance
    
    func addedStep(_ step: Step) {
        self.steps.append(step)
    }
    
    func removedStep(at offSets: IndexSet) {
        self.steps.remove(atOffsets: offSets)
    }
    
    func moved(source: IndexSet, destination: Int) {
        self.steps.move(fromOffsets: source, toOffset: destination)
    }
    
    // MARK: -
    // MARK: Combine subscriber conformance
    
    typealias Input = RecipeExecutionStepsIntentState
    typealias Failure = Never
    
    // Called by Subscriber protocol during subscription
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    // Called if the publisher says it finished emitting
    func receive(completion: Subscribers.Completion<Failure>) {
        return // TODO: see what's the use
    }
    
    // 4
    func receive(_ input: RecipeExecutionStepsIntentState) -> Subscribers.Demand {
        print("RecipeFormViewModel intent = \(input)")
        switch input {
        case .ready:
            break
        case .removingStep(let indexSet):
            self.model.removeStep(atOffsets: indexSet)
        case .movingSteps(let source, let destination):
            self.model.move(fromOffsets: source, toOffset: destination)
        case .addingStep(let step):
            self.model.addStep(step)
        }
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
