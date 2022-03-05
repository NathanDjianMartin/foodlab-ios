import SwiftUI

struct UserProfile: View {
    var user: LoggedUser
    
    var body: some View {
        HStack {
            Image(systemName: "person")
                .padding(4)
                .foregroundColor(Color.foodlabTeal)
                .font(.title)
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                Text(user.email)
                    .font(.caption)
            }
            Spacer()
            if user.isAdmin {
                Badge(text: "Admin")
            }
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile(user: LoggedUser(name: MockData.user.name, email: MockData.user.email, isAdmin: MockData.user.isAdmin))
    }
}
