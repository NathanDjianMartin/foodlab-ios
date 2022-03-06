import SwiftUI

struct IngredientListInStep: View {
    var ingredients: [Ingredient: Double]?
    
    var body: some View {
        List {
            if let ingredients = ingredients {
                ForEach(ingredients.sorted(by: >), id: \.key) { key, value in
                    HStack {
                        Text("\(key.name)")
                        Spacer()
                        Text("\(value.roundTo(2)) \(key.unit)")
                    }
                }
            } else {
                Text("There are no ingredient in this step")
            }
        }
        
    }
}

struct IngredientList_Previews: PreviewProvider {
    static var previews: some View {
        IngredientList()
    }
}
