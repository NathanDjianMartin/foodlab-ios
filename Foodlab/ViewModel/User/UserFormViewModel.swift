import Combine
import Foundation

enum InputUserError: Error {
    case unitaryPriceInputError(String)
    case stockQuantityInputError(String)
}

class UserFormViewModel : ObservableObject, Subscriber, UserObserver {
    
    private var model: User
    // save model in case the modification is cancelled
    private (set) var modelCopy: User
    
    var id: Int?
    @Published var name: String
    @Published var email: String
    @Published var password: String
    @Published var isAdmin: Bool
    @Published var error: String?
    
    init(model: User) {
        self.id = model.id
        self.name = model.name
        self.email = model.email
        self.password = model.password
        self.isAdmin = model.isAdmin
        self.model = model
        self.modelCopy = User(id: model.id, name: model.name, email: model.email, password: model.password, isAdmin: model.isAdmin)
        self.model.observer = self
    }
    
    // MARK: -
    // MARK: Track observer delegate functions
    
    func changed(name: String) {
        self.name = name
    }
    
    func changed(email: String) {
        self.email = email
    }
    
    func changed(password: String) {
        self.password = password
    }
    
    func changed(isAdmin: Bool) {
        self.isAdmin = isAdmin
    }
    
    // MARK: -
    // MARK: Subscriber conformance
    
    typealias Input = UserFormIntentState
    typealias Failure = Never
    
    // Called by Subscriber protocol during subscription
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    // Called if the publisher says it finished emitting (doesn't concern us)
    func receive(completion: Subscribers.Completion<Failure>) {
        return
    }
    
    // Called each time the publisher calls the "send" method to notify about state modification
    func receive(_ input: UserFormIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
        case .nameChanging(let name):
            let nameClean = name.trimmingCharacters(in: .whitespacesAndNewlines)
            self.modelCopy.name = nameClean
            if modelCopy.name != nameClean { // there was an error
                self.error = "The name can't be empty!"
            }
        case .emailChanging(let email):
            let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
            self.modelCopy.email = email
        case .passwordChanging(let password):
            self.modelCopy.password = password
        case .isAdminChanging(let isAdmin):
            self.modelCopy.isAdmin = isAdmin
        case .userUpdatedInDatabase:
            self.model.name = self.modelCopy.name
            self.model.email = self.modelCopy.email
            self.model.password = self.modelCopy.password
            self.model.isAdmin = self.modelCopy.isAdmin
        case .error(let errorMessage):
            self.error = errorMessage
        }
        
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
