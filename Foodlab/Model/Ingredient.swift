import Foundation

class Ingredient {
    
    var name: String
    var unit: String
    var price: Double
    var stockQuantity: Double
    var ingredientCategory: String
    var allergenCategory: String
    
    init(name: String, unit: String, price: Double, stockQuantity: Double, ingredientCategory: String, allergenCategory: String) {
        self.name = name
        self.unit = unit
        self.price = price
        self.stockQuantity = stockQuantity
        self.ingredientCategory = ingredientCategory
        self.allergenCategory = allergenCategory
    }
}
