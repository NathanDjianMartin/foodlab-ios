import SwiftUI

struct StepForm: View {
    
    //TODO: changer par SimpleStepVM
    @ObservedObject var step: SimpleStep
    @Binding var isPresented: Bool
    //TODO: il faudra surement recopier les informations et ne modifier le modelView que si on valide avec le bouton
    @State var currentIngredientToAdd: IngredientWithinStep = IngredientWithinStep(ingredient: Ingredient( name: "", unit: "", unitaryPrice: 0, stockQuantity: 0, ingredientCategory: Category(name: "")), quantity: 0)
    //TODO: il y aura un probleme quand on va merge avec mon autre branche puisque les category ne sont plus des string mais des categories
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
            .padding(.trailing)
            
            HStack {
                Text(step.id == nil ? "Step creation" : "Step modification")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding()
            
            List {
                
                Section("Step information") {
                    TextField("Step title", text: $step.title)
                    TextEditor(text: $step.description)
                    Stepper(value: $step.duration) {
                        Text(" \(step.duration) minute\(step.duration > 1 ? "s" : "")")
                    }
                }
                
                Section("Ingredients") {
                    if let ingredients = step.ingredients {
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
                            // TODO: intent to add ingredient to step
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
        StepForm(step: MockData.step, isPresented: .constant(true))
    }
}
