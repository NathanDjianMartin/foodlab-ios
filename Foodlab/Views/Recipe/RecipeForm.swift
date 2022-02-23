import SwiftUI

struct RecipeForm: View {
    
    @ObservedObject var viewModel: RecipeFormViewModel
    @Binding var isPresented: Bool
    @State private var showErrorAlert = false
    private var intent: RecipeFormIntent
    
    var creationMode: Bool {
        self.viewModel.id == nil
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
                }) {
                    Text("Cancel")
                }
            }
            .padding()
            
            HStack {
                Text(creationMode ? "Create recipe" : "Edit recipe")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding()
            
            List {
                TextField("Recipe title", text: $viewModel.title)
                    .onSubmit {
                        self.intent.intentToChange(recipeTitle: self.viewModel.title)
                    }
                TextField("Author", text: $viewModel.author)
                    .onSubmit {
                        self.intent.intentToChange(author: self.viewModel.author)
                    }
                Stepper(value: $viewModel.guestNumber, in: 1...Int.max) {
                    Text("For \(viewModel.guestNumber) guest\(viewModel.guestNumber > 1 ? "s" : "")")
                }
                HStack {
                    Spacer()
                    Button {
                        self.intent.intentToValidate()
                        self.isPresented = false
                    } label: {
                        Text("OK")
                    }
                    .buttonStyle(DarkRedButtonStyle())
                }
            }
            .listStyle(.plain)
        }
        //TODO: add button validate? 
    }
}

struct RecipeCreation_Previews: PreviewProvider {
    static var previews: some View {
        RecipeForm(viewModel: RecipeFormViewModel(model: MockData.recipePates), isPresented: .constant(true))
    }
}
