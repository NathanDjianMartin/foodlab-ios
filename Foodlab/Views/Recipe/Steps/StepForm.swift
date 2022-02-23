//
//  StepForm.swift
//  Foodlab
//
//  Created by m1 on 20/02/2022.
//

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
            .padding()
            
            HStack {
                Text(step.id == nil ? "Step creation" : "Step modification")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding()
            
            List {
                TextField("Step title", text: $step.title)
                TextEditor(text: $step.description)
                Stepper(value: $step.duration) {
                    Text(" \(step.duration) minute\(step.duration > 1 ? "s" : "")")
                }
            }
            
            VStack {
                Text("Ingredients in step")
                if let ingredients = step.ingredients {
                    List {
                        ForEach(ingredients.sorted(by: >), id: \.key) { key, value in
                            HStack {
                                Text("\(key.name)")
                                Spacer()
                                Text("\(value)\(key.unit)")
                            }
                        }
                    }
                    
            }
                
                //TODO: add selector
                Text("Add ingredient in step")
                Stepper(value: $currentIngredientToAdd.quantity) {
                    Text("\(currentIngredientToAdd.quantity) \(currentIngredientToAdd.ingredient.unit)")
                }
                HStack {
                    Spacer()
                    Button("Add ingredient") {
                        print("TODO: Add ingredient to the list!")
                    }
                    .buttonStyle(DarkRedButtonStyle())
                }
            }
            .padding()
            
            HStack {
                Spacer()
                Button("Add step") {
                    print("TODO: Add step to the list!")
                }
                .buttonStyle(DarkRedButtonStyle())
            }
            
        }.padding()
    }
}

struct StepForm_Previews: PreviewProvider {
    static var previews: some View {
        StepForm(step: MockData.step, isPresented: .constant(true))
    }
}
