import SwiftUI

struct UserList: View {
    @State private var userCreation = false
    
    var body: some View {
        List {
            Button(action: {
                userCreation = true
            }) {
                Image(systemName: "plus")
            }
            ForEach(MockData.usersList) { user in
                UserRow(user: user)
            }
        }
        .sheet(isPresented: $userCreation) {
            UserCreation()
        }
        .navigationTitle("Users")
    }
}

struct UserList_Previews: PreviewProvider {
    static var previews: some View {
        UserList()
    }
}
