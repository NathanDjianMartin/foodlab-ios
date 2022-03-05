import SwiftUI

struct SettingsSummary: View {
    @EnvironmentObject var user: LoggedUser
    
    var body: some View {
        List {
            Section(header: Text("My account")) {
                
                HStack {
                    UserProfile(user: user)
                }
                
                Button("Sign out") {
                    withAnimation(.easeOut(duration: 0.5)) {
                        user.isAuthenticated = false
                    }
                }
            }
            Section(header: Text("Settings")) {
                NavigationLink {
                    CategoryList(categoryVM: CategoryViewModel(type: CategoryType.ingredient))
                } label: {
                    Text("Ingredient Categories")
                }
                NavigationLink {
                        CategoryList(categoryVM: CategoryViewModel( type: CategoryType.allergen))
                } label: {
                    Text("Allergen Categories")
                }
                NavigationLink {
                        CategoryList(categoryVM: CategoryViewModel( type: CategoryType.recipe))
                } label: {
                    Text("Recipe Categories")
                }
                NavigationLink {
                    CostDataSettings(viewModel: CostDataViewModel(), intent: CostDataIntent())
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
        SettingsSummary()
    }
}
