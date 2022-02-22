import SwiftUI

struct RecipeRow: View {
    @ObservedObject var viewModel: RecipeRowViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .font(.headline)
                Text("By \(viewModel.author)")
                    .font(.caption)
                Text("Duration: \(viewModel.duration) minutes")
                    .font(.caption)
            }
            Spacer()
            // TODO: manage deletion with a swipe
        }
        .padding()
    }
}

struct RecipeRow_Previews: PreviewProvider {
    static var previews: some View {
        RecipeRow(viewModel: RecipeRowViewModel(model: MockData.recipeCrepes))
    }
}
