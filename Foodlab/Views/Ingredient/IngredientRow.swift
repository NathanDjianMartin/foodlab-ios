import SwiftUI

struct IngredientRow: View {
    @ObservedObject var ingredientVM: IngredientFormViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(ingredientVM.name)
                    .font(.headline)
                Text("\(ingredientVM.stockQuantity.roundTo(2))  unit in stock")
                    .font(.caption)
                Text("\(ingredientVM.unitaryPrice.roundTo(2))$ per \(ingredientVM.unit)")
                    .font(.caption)
            }
            if ingredientVM.allergenCategory != nil {
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
            IngredientRow(ingredientVM: IngredientFormViewModel(model: MockData.ingredient))
                .previewLayout(.fixed(width: 300, height: 70))
            IngredientRow(ingredientVM: IngredientFormViewModel(model: MockData.ingredient))
                .previewLayout(.fixed(width: 300, height: 70))
                .preferredColorScheme(.dark)
            IngredientRow(ingredientVM: IngredientFormViewModel(model: MockData.ingredient))
                .previewLayout(.fixed(width: 300, height: 70))
            IngredientRow(ingredientVM:IngredientFormViewModel(model: MockData.ingredient))
                .previewLayout(.fixed(width: 300, height: 70))
                .preferredColorScheme(.dark)
        }
    }
}
