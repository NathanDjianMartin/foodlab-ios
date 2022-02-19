import Foundation

protocol IngredientObserver {
    func changed(name: String)
    func changed(unit: String)
    func changed(unitaryPrice: Double)
    func changed(stockQuantity: Double)
    func changed(ingredientCategory: Category)
    func changed(allergenCategory: Category)
}

class Ingredient: Identifiable {
    
    var id: Int?
    var name: String
    var unit: String
    var unitaryPrice: Double
    var stockQuantity: Double
    var ingredientCategory: Category
    var allergenCategory: Category?
    
    var observer: IngredientObserver?
    
    init(id: Int? = nil, name: String, unit: String, unitaryPrice: Double, stockQuantity: Double, ingredientCategory: Category, allergenCategory: Category? = nil) {
        self.id = id
        self.name = name
        self.unit = unit
        self.unitaryPrice = unitaryPrice
        self.stockQuantity = stockQuantity
        self.ingredientCategory = ingredientCategory
        self.allergenCategory = allergenCategory
    }
}
