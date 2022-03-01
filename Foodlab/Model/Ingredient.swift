import Foundation

protocol IngredientObserver {
    
    func changed(name: String)
    func changed(unit: String)
    func changed(unitaryPrice: Double)
    func changed(stockQuantity: Double)
    func changed(ingredientCategory: Category)
    func changed(allergenCategory: Category?)
}

class Ingredient: Identifiable, Hashable, Comparable, CustomStringConvertible {
    
    var id: Int?
    private var observers: [IngredientObserver]
    var name: String {
        didSet { // if name was set, we should warn our observer
            if name.count <= 0 {
                name = oldValue
            } else {
                for observer in observers {
                    observer.changed(name: self.name) // this call makes possible observer to observe
                }
            }
        }
    }
    var unit: String {
        didSet { // if name was set, we should warn our observer
            for observer in observers {
                observer.changed(unit: self.unit) // this call makes possible observer to observe
            }
        }
    }
    var unitaryPrice: Double {
        didSet {
            for observer in observers {
                observer.changed(unitaryPrice: self.unitaryPrice)
            }
        }
    }
    var stockQuantity: Double {
        didSet {
            for observer in observers {
                observer.changed(stockQuantity: self.stockQuantity)
            }
        }
    }
    var ingredientCategory: Category {
        didSet {
            for observer in observers {
                observer.changed(ingredientCategory: self.ingredientCategory)
            }
        }
    }
    var allergenCategory: Category? {
        didSet {
            for observer in observers {
                observer.changed(allergenCategory: self.allergenCategory)
            }
        }
    }
    
    var description: String{
        return self.name
    }
    
    init(id: Int? = nil, name: String, unit: String, unitaryPrice: Double, stockQuantity: Double, ingredientCategory: Category, allergenCategory: Category? = nil) {
        self.observers = []
        self.id = id
        self.name = name
        self.unit = unit
        self.unitaryPrice = unitaryPrice
        self.stockQuantity = stockQuantity
        self.ingredientCategory = ingredientCategory
        self.allergenCategory = allergenCategory
    }
    
    func addObserver(_ observer: IngredientObserver) {
        self.observers.append(observer)
    }
    
    func copy() -> Ingredient {
        return Ingredient(id: self.id, name: self.name, unit: self.unit, unitaryPrice: self.unitaryPrice, stockQuantity: self.stockQuantity, ingredientCategory: self.ingredientCategory, allergenCategory: self.allergenCategory)
    }
    
    // Comform to Hashable protocol
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Comform to Comparable protocol
    static func < (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.id < rhs.id
    }
}
