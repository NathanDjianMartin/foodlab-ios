import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            NavigationView {
                IngredientList()
                    .navigationTitle("Ingredients")
            }
            .tabItem {
                Label("Ingredients", systemImage: "fork.knife")
            }
            
            NavigationView {
                RecipeList()
                    .navigationTitle("Recipes")
            }
            .tabItem {
                Label("Recipes", systemImage: "doc.text")
            }
            
            NavigationView {
                UserList()
                    .navigationTitle("Users")
            }
            .tabItem {
                Label("Users", systemImage: "person.2.fill")
            }
            
            NavigationView {
                SettingsSummary(user: MockData.user)
                    .navigationTitle("Settings")
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
