import SwiftUI

@main
struct FoodlabApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    if let ingredients = await IngredientDAO.getAllIngredients() {
                        IngredientList.ingredients = ingredients
                        //print(ingredient.ingredientCategory)
                    } else {
                        print("nil GET")
                    }
                }
        }
    }
}
