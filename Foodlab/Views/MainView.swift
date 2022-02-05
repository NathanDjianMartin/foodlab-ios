import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            IngredientCreation()
                .tabItem {
                    Label("Ingredients", systemImage: "cup.and.saucer")
                }
            RecipesList()
                .tabItem {
                    Label("Recipes", systemImage: "list.dash")
                }
            StocksList()
                .tabItem {
                    Label("Stock", systemImage: "bag.fill")
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
