import Foundation

protocol RecipeSubscriber {
    func changed(title: String)
    func changed(author: String)
    func changed(guestNumber: Int)
}

class Recipe: Identifiable, ObservableObject, NSCopying {
    
    var subscriber: RecipeSubscriber?
    var id: Int?
    var title: String {
        didSet {
            if title.count <= 0 {
                title = oldValue
            } else {
                self.subscriber?.changed(title: self.title) // TODO: vérifier si on appelle la fonction de l'observer systématiquement
            }
        }
    }
    var author: String {
        didSet {
            self.subscriber?.changed(author: self.author)
        }
    }
    var guestsNumber: Int {
        didSet {
            self.subscriber?.changed(guestNumber: self.guestsNumber)
        }
    }
    var recipeCategory: Category
    var costData: CostData
    var execution: RecipeExecution
    
    var duration: Int {
        0
    }
    
    init(id: Int? = nil, title: String, author: String, guestsNumber: Int, recipeCategory: Category, costData: CostData, execution: RecipeExecution) {
        self.id = id
        self.title = title
        
        self.author = author
        self.guestsNumber = guestsNumber
        self.recipeCategory = recipeCategory
        self.costData = costData
        self.execution = execution
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return Recipe(id: self.id,
                      title: self.title,
                      author: self.author,
                      guestsNumber: self.guestsNumber,
                      recipeCategory: self.recipeCategory,
                      costData: self.costData,
                      execution: self.execution)
    }
}
