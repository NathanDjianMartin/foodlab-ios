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
            HStack {
                Spacer()
                Button {
                    self.isPresented = false
                } label: {
                    Text("Cancel")
                }
            }
            .padding()
            
            HStack {
                Text("Add recipe execution")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding()
            
            MessageView(message: self.$viewModel.errorMessage, type: .error)
            
            List {
                ForEach(self.viewModel.recipes) { recipe in
                    RecipeRow(viewModel: RecipeRowViewModel(model: recipe))
                        .onTapGesture {
                            self.viewModel.selectedRecipe = recipe
                        }
                }
            }
            .listStyle(.plain)
            .frame(maxHeight: 500.0)
            HStack {
                Spacer()
                Button {
                    Task {
                        if var selectedRecipe = self.viewModel.selectedRecipe {
                            switch await RecipeDAO.shared.getRecipeById(selectedRecipe.id!) {
                            case .success(let recipe):
                                selectedRecipe = recipe
                            case .failure(let error):
                                self.viewModel.errorMessage = error.localizedDescription
                            }
                            if let selectedExecution = selectedRecipe.execution {
                                await self.intent.intentToAddExecution(selectedExecution, to: self.viewModel.destinationExecution)
                                if self.viewModel.errorMessage == nil {
                                    self.isPresented = false
                                }
                            } else {
                                self.viewModel.errorMessage = "The selected recipe doesn't have a recipe execution."
                            }
                        } else {
                            self.viewModel.errorMessage = "The selected recipe is nil."
                        }
                    }
                } label: {
                    if let selectedRecipe = self.viewModel.selectedRecipe {
                        Text("Add recipe \(selectedRecipe.title) as a step")
                    } else {
                        Text("Please select a recipe")
                    }
                }
                .disabled(self.viewModel.selectedRecipe == nil)
                .buttonStyle(DarkRedButtonStyle())
            }
            .padding()
            Spacer()
        }
    }
}

struct RecipeExecutionForm_Previews: PreviewProvider {
    static var previews: some View {
        RecipeExecutionForm(viewModel: RecipeExecutionFormViewModel(recipes: MockData.recipeList, execution: MockData.executionCrepes), intent: RecipeIntent(), isPresented: .constant(true))
    }
}
