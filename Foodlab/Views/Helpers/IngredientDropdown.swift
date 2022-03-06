import SwiftUI

struct IngredientDropdown: View {
    @Binding var selectedIngredient: Ingredient?
    var dropDownList: [Ingredient]
    
    init(selectedIngredient: Binding<Ingredient?> = .constant(nil), dropDownList: [Ingredient]) {
        self._selectedIngredient = selectedIngredient
        self.dropDownList = dropDownList
    }
    
    var body: some View {
        Menu {
                Button("None") {
                    self.selectedIngredient = nil
                }
            ForEach(dropDownList, id: \.self) { ingredient in
                Button {
                    self.selectedIngredient = ingredient
                } label: {
                    HStack {
                        Text(ingredient.name)
                        if selectedIngredient == ingredient {
                            Image(systemName: "checkmark")
                        }
                    }
                }

            }
        } label: {
            HStack{
                if let selectedIngredient = selectedIngredient {
                    Text(selectedIngredient.name)
                        .foregroundColor(.primary)
                } else {
                    Text("Select an ingredient")
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(Color.gray)
                    .font(Font.system(size: 20, weight: .medium))
            }
            .padding(5)
        }
    }
}

struct IngredientDropdown_Previews: PreviewProvider {
    static var previews: some View {
        IngredientDropdown(dropDownList: MockData.ingredientList)
    }
}
