import Foundation

class Ingredient: Identifiable {
    var id: Int?
    var name: String
    var unit: String
    var unitaryPrice: Double
    var stockQuantity: Double
    var ingredientCategory: String
    var allergenCategory: String?
    
    init(id: Int? = nil, name: String, unit: String, unitaryPrice: Double, stockQuantity: Double, ingredientCategory: String, allergenCategory: String? = nil) {
        self.id = id
        self.name = name
        self.unit = unit
        self.unitaryPrice = unitaryPrice
        self.stockQuantity = stockQuantity
        self.ingredientCategory = ingredientCategory
        self.allergenCategory = allergenCategory
    }
    
}
