import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            NavigationView {
                IngredientList()
            }
            .tabItem {
                Label("Ingredients", systemImage: "fork.knife")
            }
            
            NavigationView {
                RecipeList()
            }
            .tabItem {
                Label("Recipes", systemImage: "doc.text")
            }
            
            NavigationView {
                UserList()
            }
            .tabItem {
                Label("Users", systemImage: "person.2.fill")
            }
            
            NavigationView {
                SettingsSummary(user: MockData.user)
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
    }
}
