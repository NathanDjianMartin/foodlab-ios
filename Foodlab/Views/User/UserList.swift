import SwiftUI

struct UserList: View {
    
    @State private var showUserCreation = false
    @State private var userToDelete: User?
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
                case .failure(_):
                    print("error")
                case .success(let users):
                    viewModel.users = users
                }
            }
        }
        .sheet(isPresented: $showUserCreation) {
            UserCreation(isPresented: $showUserCreation)
        }
        .navigationTitle("Users")
        .toolbar {
            Button(action: {
                showUserCreation = true
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
