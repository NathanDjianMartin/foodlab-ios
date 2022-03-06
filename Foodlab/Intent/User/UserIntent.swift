import Foundation
import Combine

enum UserFormIntentState {
    case ready
    case nameChanging(String)
    case emailChanging(String)
    case passwordChanging(String)
    case isAdminChanging(Bool)
    case userUpdatedInDatabase
    case error(String)
}

enum UserListIntentState {
    case uptodate
    //case needToBeUpdated
    case addingUser(User)
    case deletingUser(Int)
    case error(String)
}

struct UserIntent {
    
    // A subject (publisher) which emits elements to its subscribers
    // IntentState = Output type
    // Never = error type
    private var formState = PassthroughSubject<UserFormIntentState, Never>()
    private var listState = PassthroughSubject<UserListIntentState, Never>()
    
    func addObserver(userFormViewModel: UserFormViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.formState.subscribe(userFormViewModel)
    }
    
    func addObserver(userListViewModel: UserListViewModel) {
        // a view model wants to be notified when this intent changes so it subscribes
        self.listState.subscribe(userListViewModel)
    }
    
    // MARK: intentToChange functions
    
    func intentToChange(name: String) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.nameChanging(name)) // emits an object of type IntentState
    }
    
    func intentToChange(email: String) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.emailChanging(email)) // emits an object of type IntentState
    }
    
    func intentToChange(password: String) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.passwordChanging(password)) // emits an object of type IntentState
    }
    
    func intentToChange(isAdmin: Bool) {
        // Notify subscribers that the state changed
        // (they can use their receive method to react to those changes)
        self.formState.send(.isAdminChanging(isAdmin)) // emits an object of type IntentState
    }
    
    func intentToCreate(user: User) async {
        if isUserValid(user: user) {
            switch await UserDAO.shared.createUser(user: user) {
            case .failure(let error):
                self.formState.send(.error("\(error.localizedDescription)"))
                break
            case .success(let user):
                // si ça a marché : modifier le view model et le model
                self.formState.send(.userUpdatedInDatabase)
                self.listState.send(.addingUser(user))
            }
        }
    }
    
    func intentToDelete(userId id: Int, userIndex: Int) async {
        switch await UserDAO.shared.deleteUserById(id) {
        case .failure(let error):
            self.listState.send(.error("Error while deleting ingredient \(id): \(error.localizedDescription)"))
        case .success:
            self.listState.send(.deletingUser(userIndex))
        }
    }
    
    private func isUserValid(user: User) -> Bool {
        if user.name == "" {
            self.formState.send(.error("Name cannot be empty"))
            return false
        } else if user.email == "" {
            // TODO: ajouter fonction avec regexp pour le mail
            
            self.formState.send(.error("Email cannot be empty"))
            return false
        } else if user.password == "" {
            self.formState.send(.error("Password cannot be empty"))
            return false
        } else {
            return true
        }
    }
    
}
