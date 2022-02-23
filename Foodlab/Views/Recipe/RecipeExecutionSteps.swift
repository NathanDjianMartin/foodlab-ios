import SwiftUI

struct RecipeExecutionSteps: View {
    var execution: RecipeExecution
    @State private var showSheet = false
    
    var body: some View {
        List {
            ForEach(execution.steps.indices) { index in
                let displayIndex = index + 1
                if let simpleStep = execution.steps[index] as? SimpleStep {
                    SimpleStepRow(step: simpleStep, index: displayIndex)
                        .fixedSize(horizontal: false, vertical: true) 
                } else if let execution = execution.steps[index] as? RecipeExecution {
                    NavigationLink {
                        RecipeExecutionSteps(execution: execution)
                            .navigationTitle(execution.title)
                    } label: {
                        RecipeExecutionRow(execution: execution, index: displayIndex)
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
