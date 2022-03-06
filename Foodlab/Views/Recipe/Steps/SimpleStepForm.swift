import SwiftUI

struct SimpleStepForm: View {
    
    @Binding var presentedStep: SimpleStep?
    @ObservedObject var viewModel: SimpleStepFormViewModel
    private var intent: SimpleStepIntent
    
    var creationMode: Bool {
        self.viewModel.id == nil
    }
    
    init(viewModel: SimpleStepFormViewModel, presentedStep: Binding<SimpleStep?>) {
        self.viewModel = viewModel
        self._presentedStep = presentedStep
        
        self.intent = SimpleStepIntent()
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
            
            HStack {
                Text(creationMode ? "Step creation" : "Step modification")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding()
            
            List {
                
                Section("Step information") {
                    TextField("Step title", text: $viewModel.title)
                    TextEditor(text: $viewModel.description)
                    Stepper(value: $viewModel.duration) {
                        Text(" \(viewModel.duration) minute\(viewModel.duration > 1 ? "s" : "")")
                    }
                }
                
                Section("Ingredients") {
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
                
                VStack {
                    HStack {
                        // TODO: make an ingredient dropdown
                        CategoryDropdown(dropDownList: MockData.allergenCategories)
                        
                    }
                    Stepper(value: $currentIngredientToAdd.quantity) {
                        Text("\(currentIngredientToAdd.quantity)/\(currentIngredientToAdd.ingredient.unit)")
                    }
                    HStack {
                        Spacer()
                        Button() {
                            // TODO: intentToAddIngredientToStep(...)
                        } label: {
                            Label("Add ingredient", systemImage: "plus")
                                .foregroundColor(Color.foodlabRed)
                        }
                        .padding(.top)
                    }
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke()
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Spacer()
                    Button("OK") {
                        // TODO: if edit mode...
                    }
                    .buttonStyle(DarkRedButtonStyle())
                }
                
            }
            .listStyle(.plain)
        }
    }
}

struct StepForm_Previews: PreviewProvider {
    static var previews: some View {
        SimpleStepForm(viewModel: SimpleStepFormViewModel(model: MockData.step), presentedStep: .constant(MockData.step))
    }
}