import SwiftUI

@main
struct FoodlabApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    if(IngredientList.ingredients == nil || IngredientList.ingredients?.count == 0){
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
}
