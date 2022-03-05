import Foundation

protocol RecipeSubscriber {
    func changed(title: String)
    func changed(author: String)
    func changed(guestNumber: Int)
}

class Recipe: Identifiable, ObservableObject, NSCopying {
    
    private var subscribers: [RecipeSubscriber]
    var id: Int? // RecipeDTO
    var title: String { // RecipeDTO
        didSet {
            if title.count <= 0 {
                title = oldValue
            } else {
                for subscriber in self.subscribers {
                    subscriber.changed(title: self.title)
                    self.execution?.title = title // updates the execution title
                }
            }
        }
    }
    var author: String { // RecipeDTO
        didSet {
            for subscriber in self.subscribers {
                subscriber.changed(author: self.author)
            }
        }
    }
    var guestsNumber: Int { // RecipeDTO
        didSet {
            for subscriber in self.subscribers {
                subscriber.changed(guestNumber: self.guestsNumber)
            }
        }
    }
    var recipeCategory: Category
    var costData: CostData
    var execution: RecipeExecution?
    
    var duration: Int {
        0
    }
    
    init(id: Int? = nil, title: String, author: String, guestsNumber: Int, recipeCategory: Category, costData: CostData, execution: RecipeExecution?) {
        self.id = id
        self.title = title
        
        self.subscribers = []
        self.author = author
        self.guestsNumber = guestsNumber
        self.recipeCategory = recipeCategory
        self.costData = costData
        self.execution = execution
    }
    
    func addSubscriber(_ subscriber: RecipeSubscriber) {
        self.subscribers.append(subscriber)
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
