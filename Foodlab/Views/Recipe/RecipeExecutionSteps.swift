import SwiftUI

struct RecipeExecutionSteps: View {
    //var execution: RecipeExecution
    @ObservedObject var viewModel: RecipeExecutionStepsViewModel
    private var intent: RecipeIntent
    
    @State private var showSheet = false
    
    init(viewModel: RecipeExecutionStepsViewModel, intent: RecipeIntent) {
        self.viewModel = viewModel
        self.intent = intent
        self.intent.addObserver(self.viewModel)
    }
    
    var body: some View {
        List {
            let execution = self.viewModel.model
            ForEach(execution.steps.indices) { index in
                let displayIndex = index + 1
                if let simpleStep = execution.steps[index] as? SimpleStep {
                    SimpleStepRow(step: simpleStep, index: displayIndex)
                        .fixedSize(horizontal: false, vertical: true)
                        .onTapGesture {
                            self.showSheet = true
                        }
                } else if let execution = execution.steps[index] as? RecipeExecution {
                    NavigationLink {
                        RecipeExecutionSteps(viewModel: RecipeExecutionStepsViewModel(model: execution), intent: self.intent)
                            .navigationTitle(execution.title)
                    } label: {
                        RecipeExecutionRow(execution: execution, index: displayIndex)
                    }
                }
            }
            .sheet(isPresented: $showSheet) {
                StepForm(step: MockData.step, isPresented: $showSheet)
            }
        }
        .toolbar {
            EditButton()
        }
        .listStyle(.plain)
    }
}

struct RecipeExecutionDetails_Previews: PreviewProvider {
    static var previews: some View {
        RecipeExecutionSteps(viewModel: RecipeExecutionStepsViewModel(model: MockData.executionPates), intent: RecipeIntent())
    }
}
