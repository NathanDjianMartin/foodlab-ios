import SwiftUI

struct SimpleStepForm: View {
    
    @Binding var presentedStep: SimpleStep?
    @ObservedObject var viewModel: SimpleStepFormViewModel
    private var intent: RecipeIntent
    @State var selectedIngredient: Ingredient?
    @State var quantity: Double = 0
    @State var ingredientList: [Ingredient] = []
    
    var creationMode: Bool {
        self.viewModel.id == nil
    }
    
    init(viewModel: SimpleStepFormViewModel, presentedStep: Binding<SimpleStep?>, intent: RecipeIntent) {
        self.viewModel = viewModel
        self._presentedStep = presentedStep
        
        self.intent = intent
        self.intent.addObserver(self.viewModel)
    }
    
    @State var currentIngredientToAdd: IngredientWithinStep = IngredientWithinStep(ingredient: Ingredient( name: "", unit: "", unitaryPrice: 0, stockQuantity: 0, ingredientCategory: Category(name: "")), quantity: 0)
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.presentedStep = nil
                }) {
                    Text("Cancel")
                }
            }
            .padding(.trailing)
            .padding(.top)
            
            HStack {
                Text(creationMode ? "Step creation" : "Step modification")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding()
            
            MessageView(message: self.$viewModel.errorMessage, type: .error)
            
            List {
                
                Section("Step information") {
                    TextField("Step title", text: $viewModel.title)
                        .onSubmit {
                            self.intent.intentToChange(stepTitle: viewModel.title)
                        }
                    TextEditor(text: $viewModel.description)
                        .onSubmit {
                            self.intent.intentToChange(stepDescription: viewModel.description)
                        }
                    Stepper(value: $viewModel.duration) {
                        Text(" \(viewModel.duration) minute\(viewModel.duration > 1 ? "s" : "")")
                    }
                    .onChange(of: self.viewModel.duration) { duration in
                        self.intent.intentToChange(duration: self.viewModel.duration)
                    }
                }
                
                Section("Step ingredients") {
                    if let ingredients = viewModel.ingredients {
                        ForEach(ingredients.sorted(by: >), id: \.key) { key, value in
                            HStack {
                                Text("\(key.name)")
                                Spacer()
                                Text("\(value)\(key.unit)")
                            }
                        }
                    }
                }
                
                Section("Add ingredient") {
                    VStack {
                        HStack {
                            
                            IngredientDropdown(selectedIngredient: $selectedIngredient, dropDownList: ingredientList)
                            
                        }
                        if let selectedIngredient = selectedIngredient {
                            Stepper(value: $quantity) {
                                Text("\(quantity)/\(selectedIngredient.unit)")
                            }
                        } else {
                        }
                        
                    }
                    .padding()
                }
                HStack {
                    Spacer()
                    Button() {
                        if let ingredient = selectedIngredient {
                            self.intent.intentToAddIngredientInStep(ingredient: (ingredient, quantity))
                        }
                    } label: {
                        Label("Add ingredient", systemImage: "plus")
                            .foregroundColor(Color.foodlabRed)
                    }
                    .padding(.top)
                }
                
                
                HStack {
                    Spacer()
                    Button("OK") {
                        if creationMode {
                            Task {
                                await self.intent.intentToAddSimpleStep(self.viewModel.modelCopy, to: self.viewModel.recipeExecution)
                                self.presentedStep = nil
                            }
                        } else {
                            
                        }
                    }
                    .buttonStyle(DarkRedButtonStyle())
                }
                
            }
            .listStyle(.plain)
        }
        .onAppear{
            Task {
                switch await IngredientDAO.shared.getAllIngredients() {
                case .failure(let error):
                    print(error)
                    self.viewModel.errorMessage = "Error while fletching ingredients"
                case .success(let ingredients):
                    ingredientList = ingredients
                    
                }
            }
        }
    }
}

struct StepForm_Previews: PreviewProvider {
    static var previews: some View {
        SimpleStepForm(viewModel: SimpleStepFormViewModel(model: MockData.step, recipeExecution: MockData.executionCrepes), presentedStep: .constant(MockData.step), intent: RecipeIntent())
    }
}
