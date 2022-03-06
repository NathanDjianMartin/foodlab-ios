import Foundation
import Combine

enum SimpleStepFormIntentState {
    case ready
}

struct SimpleStepIntent {
    
    private var formState = PassthroughSubject<SimpleStepFormIntentState, Never>()
    
    func addObserver(_ observer: SimpleStepFormViewModel) {
        self.formState.subscribe(observer)
    }
    
    // TODO: intent to change functions
}
