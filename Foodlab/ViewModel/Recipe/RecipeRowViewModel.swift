import Foundation

class RecipeRowViewModel: ObservableObject, RecipeSubscriber {
    
    private var model: Recipe
    @Published var title: String
    @Published var author: String
    @Published var duration: Int
    
    init(model: Recipe) {
        self.model = model
        self.title = model.title
        self.author = model.author
        self.duration = model.duration
        self.model.addSubscriber(self)
    }
    
    func changed(title: String) {
        self.title = title
    }
    
    func changed(author: String) {
        self.author = author
    }
    
    func changed(guestNumber: Int) {
        return 
    }
}
