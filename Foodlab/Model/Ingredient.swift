import Foundation

protocol IngredientObserver {
    func changed(name: String)
    func changed(unit: String)
    func changed(unitaryPrice: Double)
    func changed(stockQuantity: Double)
    func changed(ingredientCategory: Category)
    func changed(allergenCategory: Category?)
}

class Ingredient: Identifiable {
    
    var id: Int?
    var name: String {
        didSet { // if name was set, we should warn our observer
            self.observer?.changed(name: self.name) // this call makes possible observer to observe
        }
    }
    var unit: String {
        didSet { // if name was set, we should warn our observer
            self.observer?.changed(unit: self.unit) // this call makes possible observer to observe
        }
    }
    var unitaryPrice: Double {
        didSet {
            self.observer?.changed(unitaryPrice: self.unitaryPrice)
        }
    }
    var stockQuantity: Double {
        didSet {
            self.observer?.changed(stockQuantity: self.stockQuantity)
        }
    }
    var ingredientCategory: Category {
        didSet {
            self.observer?.changed(ingredientCategory: self.ingredientCategory)
        }
    }
    var allergenCategory: Category? {
        didSet {
            self.observer?.changed(allergenCategory: self.allergenCategory)
        }
    }
    
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
