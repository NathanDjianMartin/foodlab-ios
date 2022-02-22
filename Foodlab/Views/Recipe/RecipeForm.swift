import SwiftUI

struct RecipeForm: View {
    
    @ObservedObject var viewModel: RecipeFormViewModel
    @Binding var isPresented: Bool
    @State private var showErrorAlert = false
    private var intent: RecipeFormIntent
    
    var creationMode: Bool {
        self.viewModel.recipeId == nil
    }
    
    init(viewModel: RecipeFormViewModel, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self._isPresented = isPresented
        self.intent = RecipeFormIntent()
        self.intent.addObserver(self.viewModel)
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.isPresented = false
                    if creationMode == false { // we are in the case of a modification
                        self.viewModel.rollback()
                    }
                }) {
                    Text("Cancel")
                }
            }
            .padding()
            
            HStack {
                Text(creationMode ? "Recipe creation" : "Recipe modification")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding()
            
            List {
                TextField("Recipe title", text: $viewModel.recipeTitle)
                    .onSubmit {
                        self.intent.intentToChange(recipeTitle: self.viewModel.recipeTitle)
                    }
                TextField("Author", text: $viewModel.recipeAuthor)
                    .onSubmit {
                        self.intent.intentToChange(author: self.viewModel.recipeAuthor)
                    }
                Stepper(value: $viewModel.recipeGuestNumber, in: 1...Int.max) {
                    Text("For \(viewModel.recipeGuestNumber) guest\(viewModel.recipeGuestNumber > 1 ? "s" : "")")
                }
                HStack {
                    Spacer()
                    Button {
                        // TODO: intentToUpdate recipe list
                        
                    } label: {
                        Text(creationMode ? "Create recipe" : "Confirm changes")
                    }
                    .buttonStyle(DarkRedButtonStyle())
                }
            }
            .listStyle(.plain)
        }
    }
}

struct RecipeCreation_Previews: PreviewProvider {
    static var previews: some View {
        RecipeForm(viewModel: RecipeFormViewModel(model: MockData.recipePates), isPresented: .constant(true))
    }
}
