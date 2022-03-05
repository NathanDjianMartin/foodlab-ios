import SwiftUI

struct UserList: View {
    
    @State private var showUserCreation = false
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
            }
        }
        .onAppear(){
            Task {
                switch await UserDAO.getAllUsers() {
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
