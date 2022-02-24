import Foundation

class IngredientListViewModel: ObservableObject {
    
    @Published var ingredients : [Ingredient]
    
    init(ingredients: [Ingredient] = []) {
        self.ingredients = ingredients
    }
}
