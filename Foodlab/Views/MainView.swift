import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var loggedUser: LoggedUser
    
    var body: some View {
        TabView {
            NavigationView {
                IngredientList()
            }
            .tabItem {
                Label("Ingredients", systemImage: "fork.knife")
            }
            
            NavigationView {
                RecipeList(viewModel: RecipeListViewModel())
            }
            .tabItem {
                Label("Recipes", systemImage: "doc.text")
            }
            if loggedUser.isAdmin {
                NavigationView {
                    UserList()
                }
                .tabItem {
                    Label("Users", systemImage: "person.2.fill")
                }
            }
            
            NavigationView {
                SettingsSummary(user: loggedUser)
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
