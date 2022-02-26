import Combine
import Foundation

enum InputIngredientError: Error {
    case unitaryPriceInputError(String)
    case stockQuantityInputError(String)
}

class IngredientFormViewModel : ObservableObject, Subscriber, IngredientObserver {
    
    private var model: Ingredient
    // save model in case the modification is cancelled
    private (set) var modelCopy: Ingredient
    
    var id: Int?
    @Published var name: String
    @Published var unit: String
    @Published var unitaryPrice: Double
    @Published var stockQuantity: Double
    @Published var ingredientCategory: Category
    @Published var allergenCategory: Category?
    @Published var error: String?
    
    init(model: Ingredient) {
        self.id = model.id
        self.name = model.name
        self.unit = model.unit
        self.unitaryPrice = model.unitaryPrice
        self.stockQuantity = model.stockQuantity
        self.ingredientCategory = model.ingredientCategory
        self.allergenCategory = model.allergenCategory
        self.model = model
        self.modelCopy = model.copy()
        self.model.addObserver(self)
    }
    
    // MARK: -
    // MARK: Track observer delegate functions
    
    func changed(name: String) {
        self.name = name
    }
    
    func changed(unit: String) {
        self.unit = unit
    }
    
    func changed(unitaryPrice: Double) {
        self.unitaryPrice = unitaryPrice
    }
    
    func changed(stockQuantity: Double) {
        self.stockQuantity = stockQuantity
    }
    
    func changed(ingredientCategory: Category) {
        self.ingredientCategory = ingredientCategory
    }
    
    func changed(allergenCategory: Category?) {
        self.allergenCategory = allergenCategory
    }
    
    // MARK: -
    // MARK: Subscriber conformance
    
    typealias Input = IngredientFormIntentState
    typealias Failure = Never
    
    // Called by Subscriber protocol during subscription
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    // Called if the publisher says it finished emitting (doesn't concern us)
    func receive(completion: Subscribers.Completion<Failure>) {
        return
    }
    
    // Called each time the publisher calls the "send" method to notify about state modification
    func receive(_ input: IngredientFormIntentState) -> Subscribers.Demand {
        switch input{
        case .ready:
            break
        case .nameChanging(let name):
            let nameClean = name.trimmingCharacters(in: .whitespacesAndNewlines)
            self.modelCopy.name = nameClean
            if modelCopy.name != nameClean { // there was an error
                self.error = "The name can't be empty!"
            }
        case .unitChanging(let unit):
            let unitClean = unit.trimmingCharacters(in: .whitespacesAndNewlines)
            self.modelCopy.unit = unitClean
        case .unitaryPriceChanging(let unitaryPrice):
            let unitaryPriceClean = Double(unitaryPrice)
            self.modelCopy.unitaryPrice = unitaryPriceClean
        case .stockQuantityChanging(let stockQuantity):
            let stockQuantityClean = Double(stockQuantity)
            self.modelCopy.stockQuantity = stockQuantityClean
        case .ingredientCategoryChanging(let ingredientCategory):
            self.modelCopy.ingredientCategory = ingredientCategory
        case .allergenCategoryChanging(let allergenCategory):
            self.modelCopy.allergenCategory = allergenCategory
        case .ingredientUpdatedInDatabase:
            self.model.name = self.modelCopy.name
            self.model.unit = self.modelCopy.unit
            self.model.unitaryPrice = self.modelCopy.unitaryPrice
            self.model.stockQuantity = self.modelCopy.stockQuantity
            self.model.ingredientCategory = self.modelCopy.ingredientCategory
            self.model.allergenCategory = self.modelCopy.allergenCategory
        }
        return .none // on arrête de traiter cette demande et on attend un nouveau send
    }
}
