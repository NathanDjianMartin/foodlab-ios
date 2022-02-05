import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            IngredientList()
                .tabItem {
                    Label("Ingredients", systemImage: "cup.and.saucer")
                }
            RecipeList()
                .tabItem {
                    Label("Recipes", systemImage: "list.dash")
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
