import SwiftUI

@main
struct FoodlabApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    print("début")
                    await IngredientDAO.updateIngredient(ingredient: Ingredient(id: 30, name: "Crevettes", unit: "Kg", unitaryPrice: 2.0, stockQuantity: 2.0, ingredientCategory: Category(id: 19, name: "Poisson et crustacés"), allergenCategory: Category(id: 15, name: "Poisson et crustacés")))
                    print("fin")
                
                }
        }
    }
}
