import SwiftUI

struct RecipeExecutionSteps: View {
    @ObservedObject var viewModel: RecipeExecutionStepsViewModel
    private var intent: RecipeIntent
    
    @State private var showSheet = false
    
    init(viewModel: RecipeExecutionStepsViewModel, intent: RecipeIntent) {
        self.viewModel = viewModel
        self.intent = intent
        self.intent.addObserver(self.viewModel)
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                EditButton()
            }
            .padding()
            List {
                let steps = self.viewModel.steps
                ForEach(Array(zip(steps.indices, steps)), id: \.0) { (index, step) in
                    let displayIndex = index + 1
                    if let simpleStep = step as? SimpleStep {
                        SimpleStepRow(step: simpleStep, index: displayIndex)
                            .fixedSize(horizontal: false, vertical: true)
                            .onTapGesture {
                                self.showSheet = true
                            }
                    } else if let execution = step as? RecipeExecution {
                        NavigationLink {
                            RecipeExecutionSteps(viewModel: RecipeExecutionStepsViewModel(model: execution), intent: self.intent)
                                .navigationTitle(execution.title)
                        } label: {
                            RecipeExecutionRow(execution: execution, index: displayIndex)
                        }
                    }
                }
                .onDelete { indexSet in
                    for i in indexSet {
                        print("onDelete: \(i)")
                    }
                    self.intent.intentToRemoveStep(at: indexSet)
                }
                .sheet(isPresented: $showSheet) {
                    StepForm(step: MockData.step, isPresented: $showSheet)
                }
            }
            .listStyle(.plain)
        }
    }
}

struct RecipeExecutionDetails_Previews: PreviewProvider {
    static var previews: some View {
        RecipeExecutionSteps(viewModel: RecipeExecutionStepsViewModel(model: MockData.executionPates), intent: RecipeIntent())
    }
}
