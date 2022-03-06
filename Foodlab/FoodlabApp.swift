import SwiftUI

@main
struct FoodlabApp: App {
    //static var apiUrl = "http://51.75.248.77:3000/"
    static var apiUrl = "http://localhost:3000/"
    
    var body: some Scene {
        WindowGroup {
            ContentView()            
                .task {
                    print("début")
                    /* Test : ok
                    let ingredient = Ingredient(id: 50,name: "", unit: "", unitaryPrice: 3, stockQuantity: 3, ingredientCategory: Category(id: 10, name: ""))
                    let ingredients = await IngredientWithinStepDAO.addIngredientsInSimpleStep(stepId: 34, ingredients: [ingredient:2])
                    print(ingredients)
                    print("fin")
                    */
                    let costData = await CostDataDAO.shared.getCostData(id: 1)
                    print(costData)
                
                }
        }
    }
}
