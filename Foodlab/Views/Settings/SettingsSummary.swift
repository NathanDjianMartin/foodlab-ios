import SwiftUI

struct SettingsSummary: View {
    var user: User
    
    var body: some View {
        List {
            Section(header: Text("My account")) {
                
                HStack {
                    UserProfile(user: user)
                }
                
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
                    CostDataSettings()
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
