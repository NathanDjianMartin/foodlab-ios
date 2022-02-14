import SwiftUI

struct SettingsSummary: View {
    var user: User
    
    var body: some View {
        List {
            Section(header: Text("My account")) {
                
                HStack {
                    // TODO: faire une vue dédié
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
                
                Button("Sign out") {
                    withAnimation(.easeOut(duration: 0.5)) {
                    }
                }
            }
            Section(header: Text("Settings")) {
                NavigationLink {
                    CategoryList(categories: MockData.ingredientCategoriesModel)
                } label: {
                    Text("Ingredient Categories")
                }
                NavigationLink {
                    CategoryList(categories: MockData.allergenCategoriesModel)
                } label: {
                    Text("Allergen Categories")
                }
                NavigationLink {
                    CategoryList(categories: MockData.recipeCategoriesModel)
                } label: {
                    Text("Recipe Categories")
                }
                NavigationLink {
                    CategoryList(categories: MockData.ingredientCategoriesModel)
                } label: {
                    Text("Cost Data")
                }
                
            }
            
        }
        .navigationTitle("Settings")
    }
}

struct SettingsSummary_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSummary(user: MockData.user)
    }
}
