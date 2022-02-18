import SwiftUI

@main
struct FoodlabApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    if let ingredient = await IngredientDAO.getIngredientById(id: 30) {
                        IngredientList.ingredients = [ingredient]
                        print(ingredient.ingredientCategory)
                    } else {
                        print("nil GET")
                    }
                }
        }
    }
}
