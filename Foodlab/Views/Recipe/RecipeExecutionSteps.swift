import SwiftUI

struct RecipeExecutionSteps: View {
    var execution: RecipeExecution
    @State private var showSheet = false
    
    var body: some View {
        List {
            ForEach(execution.steps, id: \.id) { step in
                if let simpleStep = step as? SimpleStep {
                    SimpleStepRow(step: simpleStep)
                        .fixedSize(horizontal: false, vertical: true) 
                } else if let execution = step as? RecipeExecution {
                    NavigationLink {
                        RecipeExecutionSteps(execution: execution)
                            .navigationTitle(execution.title)
                    } label: {
                        RecipeExecutionRow(execution: execution)
                    }
                }
            }
            .onTapGesture {
                self.showSheet = true
            }
            .sheet(isPresented: $showSheet) {
                StepForm(step: MockData.step, isPresented: $showSheet)
            }
        }
        .listStyle(.plain)
    }
}

struct RecipeExecutionDetails_Previews: PreviewProvider {
    static var previews: some View {
        RecipeExecutionSteps(execution: MockData.executionPates)
    }
}
