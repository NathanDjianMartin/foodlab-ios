import Foundation

class RecipeDetailsViewModel: ObservableObject, RecipeSubscriber {

    var model: Recipe
    @Published var title: String
    @Published var author: String
    @Published var category: Category
    @Published var guestNumber: Int
    
    init(model: Recipe) {
        self.model = model
        self.title = model.title
        self.author = model.author
        self.category = model.recipeCategory
        self.guestNumber = model.guestsNumber
        self.model.addSubscriber(self)
    }
    
    func changed(title: String) {
        self.title = title
    }
    
    func changed(author: String) {
        self.author = author
    }
    
    func changed(guestNumber: Int) {
        self.guestNumber = guestNumber
    }
}
