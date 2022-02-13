import SwiftUI

struct SettingsSummary: View {
    var user: User
    
    var body: some View {
        List {
            Section(header: Text("My account")) {
                
                HStack {
                    //TODO: faire une vue dédié 
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
                }
                .navigationTitle("Account")
                
                Text("Sign out")
                    .navigationTitle("Signout")
                
                
            }
            Section(header: Text("Settings")) {
                NavigationLink {
                    UserCreation()
                } label: {
                    Text("Ingredient Categories")
                }
                Text("Allergen Categories")
                    .navigationTitle("")
                Text("Recipe Categories")
                    .navigationTitle("")
                Text("Cost data")
                    .navigationTitle("")
                
            }
            
        }
        Text("Settings Summary")
    }
    
}

struct SettingsSummary_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSummary(user: MockData.user)
    }
}
