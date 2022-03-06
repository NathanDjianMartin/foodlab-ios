import SwiftUI

struct UserList: View {
    
    //@State private var showUserCreation = false
    
    @State private var showAlert = false
    @State private var userToDelete: User?
    @State private var userToCreate: User?
    @ObservedObject var viewModel: UserListViewModel
    private var intent: UserIntent
    
    init() {
        self.viewModel = UserListViewModel()
        self.intent = UserIntent()
        self.intent.addObserver(userListViewModel: viewModel)
    }
    
    var body: some View {
        List {
            ForEach(viewModel.users) { user in
                UserRow(user: user)
                    .swipeActions {
                        Button {
                            self.showAlert = true
                            self.userToDelete = user
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.foodlabRed)
                    }
                    .confirmationDialog("Delete user?", isPresented: $showAlert) {
                        Button(role: .cancel) {
                        } label: {
                            Text("No")
                        }
                        Button(role: .destructive) {
                            guard let userToDelete = userToDelete else {
                                return
                            }
                            guard let id = userToDelete.id else {
                                return
                            }
                            guard let indexToDelete = self.viewModel.users.firstIndex(of: userToDelete) else {
                                return
                            }
                            self.showAlert = false
                            Task {
                                await self.intent.intentToDelete(userId: id, userIndex: indexToDelete)
                            }
                        } label: {
                            Text("Yes")
                        }
                    }
            }
        }
        .onAppear(){
            Task {
                switch await UserDAO.shared.getAllUsers() {
                case .failure(let error):
                    print(error)
                case .success(let users):
                    viewModel.users = users
                }
            }
        }
        .sheet(item: self.$userToCreate) { user in
            UserCreation(userVM: UserFormViewModel(model: user), intent: self.intent, isPresented: $userToCreate)
        }
        .navigationTitle("Users")
        .toolbar {
            Button(action: {
                self.userToCreate = User(name: "", email: "", password: "", isAdmin: false)
            }) {
                Image(systemName: "plus")
            }
        }
    }
}

struct UserList_Previews: PreviewProvider {
    static var previews: some View {
        UserList()
    }
}
