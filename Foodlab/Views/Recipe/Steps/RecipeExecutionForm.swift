import SwiftUI

struct RecipeExecutionForm: View {
    
    private var intent: RecipeIntent
    @ObservedObject var viewModel: RecipeExecutionFormViewModel
    
    @Binding var isPresented: Bool
    
    init(viewModel: RecipeExecutionFormViewModel, intent: RecipeIntent, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.intent = intent
        self._isPresented = isPresented
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(self.viewModel.recipes) { recipe in
                    RecipeRow(viewModel: RecipeRowViewModel(model: recipe))
                }
            }
        }
    }
}

struct RecipeExecutionForm_Previews: PreviewProvider {
    static var previews: some View {
        RecipeExecutionForm(viewModel: RecipeExecutionFormViewModel(recipes: MockData.recipeList), intent: RecipeIntent(), isPresented: .constant(true))
    }
}
