import SwiftUI

struct RecipeForm: View {
    
    @ObservedObject var viewModel: RecipeFormViewModel
    @Binding var isPresented: Bool
    @State private var showErrorAlert = false
    private var intent: RecipeIntent
    
    var creationMode: Bool {
        self.viewModel.id == nil
    }
    
    init(viewModel: RecipeFormViewModel, intent: RecipeIntent, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.intent = intent
        self._isPresented = isPresented
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
            ErrorView(error: $viewModel.errorMessage)
            HStack {
                Text(creationMode ? "Create recipe" : "Edit recipe")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding()
            
            List {
                HStack {
                    TextField("Recipe title", text: $viewModel.title)
                        .onSubmit {
                            self.intent.intentToChange(recipeTitle: self.viewModel.title)
                        }
                    Divider()
                    Text("by")
                        .foregroundColor(.secondary)
                    TextField("Author", text: $viewModel.author)
                        .onSubmit {
                            self.intent.intentToChange(author: self.viewModel.author)
                        }
                }
                Stepper(value: $viewModel.guestNumber, in: 1...Int.max) {
                    Text("For \(viewModel.guestNumber) guest\(viewModel.guestNumber > 1 ? "s" : "")")
                }
                .onChange(of: self.viewModel.guestNumber) { guestNumber in
                    self.intent.intentToChange(guestNumber: self.viewModel.guestNumber)
                }
                CategoryDropdown(selectedCategory: self.$viewModel.category, placeholder: "Recipe category", dropDownList: MockData.recipeCategoriesModel, canBeEmpty: false)
                    .onChange(of: self.viewModel.category) { category in
                        if let realCategory = category {
                            self.intent.intentToChange(category: realCategory)
                        }
                    }
                
                HStack {
                    Spacer()
                    Button {
                        //self.intent.intentToValidate()
                        //self.isPresented = false
                        if creationMode {
                            Task {
                                await self.intent.intentToCreate(recipe: self.viewModel.modelCopy)
                                if self.viewModel.errorMessage == nil {
                                    self.isPresented = false
                                }
                            }
                        }
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
        RecipeForm(viewModel: RecipeFormViewModel(model: MockData.recipePates), intent: RecipeIntent(), isPresented: .constant(true))
    }
}
