import SwiftUI

struct IngredientRow: View {
    var ingredient: Ingredient
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(ingredient.name)
                    .font(.headline)
                Text("\(ingredient.stockQuantity.roundTo(2))  unit in stock")
                    .font(.caption)
                Text("\(ingredient.price.roundTo(2))$ per \(ingredient.unit)")
                    .font(.caption)
            }
            if ingredient.allergenCategory != nil {
                Spacer()
                Badge(text: "Allergen")
            }
            Spacer()
            // TODO: swipe modification
            // TODO: swipe delete
        }
        .padding()
    }
}

struct IngredientRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IngredientRow(ingredient: MockData.ingredient)
                .previewLayout(.fixed(width: 300, height: 70))
            IngredientRow(ingredient: MockData.ingredient)
                .previewLayout(.fixed(width: 300, height: 70))
                .preferredColorScheme(.dark)
            IngredientRow(ingredient: MockData.allergenIngredient)
                .previewLayout(.fixed(width: 300, height: 70))
            IngredientRow(ingredient: MockData.allergenIngredient)
                .previewLayout(.fixed(width: 300, height: 70))
                .preferredColorScheme(.dark)
        }
    }
}
