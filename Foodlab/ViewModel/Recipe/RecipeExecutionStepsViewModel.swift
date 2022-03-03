import Foundation
import Combine

class RecipeExecutionStepsViewModel: ObservableObject, Subscriber {
    
    private (set) var model: RecipeExecution
    @Published var steps: [Step]
    
    init(model: RecipeExecution) {
        self.model = model
        self.steps = model.steps
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
        }
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
