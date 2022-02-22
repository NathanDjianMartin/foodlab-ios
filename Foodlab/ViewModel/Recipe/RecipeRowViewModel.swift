import Foundation

class RecipeRowViewModel: ObservableObject {
    
    private var model: Recipe
    @Published var title: String
    @Published var author: String
    @Published var duration: Int
    
    init(model: Recipe) {
        self.model = model
        self.title = model.title
        self.author = model.author
        self.duration = model.duration
    }
}
