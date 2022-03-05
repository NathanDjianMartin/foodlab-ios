import Combine
import Foundation

class UserListViewModel: ObservableObject, Subscriber {
    
    @Published var users : [User]
    @Published var error: String?
    
    init(users: [User] = []) {
        self.users = users
    }
    
    // MARK: -
    // MARK: Subscriber conformance
    
    typealias Input = UserListIntentState
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
    func receive(_ input: UserListIntentState) -> Subscribers.Demand {
        switch input {
        case .uptodate:
            break
        case .addingUser(let user):
            self.users.append(user)
        case .deletingUser(let userIndex):
            let user = self.users.remove(at: userIndex)
            print("Deleting \(user.name) of index \(userIndex)")
        case .error(let errorMessage):
            self.error = errorMessage
        }
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
