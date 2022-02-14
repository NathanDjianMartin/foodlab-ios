import SwiftUI

struct UserList: View {
    @State private var showUserCreation = false
    
    var body: some View {
        List {
            ForEach(MockData.usersList) { user in
                UserRow(user: user)
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
