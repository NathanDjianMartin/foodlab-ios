import SwiftUI

struct RecipeExecutionRow: View {
    var execution: RecipeExecution
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                StepIndexCircle(stepNumber: 1)
                Text(execution.title)
                    .bold()
                Spacer()
                Badge(text: "Recipe", color: .foodlabLightBrown)
            }
        }
        .padding()
    }
}

struct RecipeExecutionRow_Previews: PreviewProvider {
    static var previews: some View {
        RecipeExecutionRow(execution: MockData.executionPates)
    }
}
