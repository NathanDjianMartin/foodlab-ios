import SwiftUI

@main
struct FoodlabApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    if let ingredients = await IngredientDAO.getAllIngredients() {
                        IngredientList.ingredients = ingredients
                        print(ingredients)
                    } else {
                        print("nil GET")
                    }
                }
        }
    }
}
