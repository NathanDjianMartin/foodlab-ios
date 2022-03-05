import SwiftUI

struct RecipeExecutionSteps: View {
    @Environment(\.editMode) private var editMode
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
                    self.intent.intentToRemoveStep(at: indexSet)
                }
                .onMove { source, destination in
                    self.intent.intentToMoveSteps(source: source, destination: destination)
                }
                .sheet(isPresented: $showSheet) {
                    StepForm(step: MockData.step, isPresented: $showSheet)
                }
            }
            .listStyle(.plain)
        }
        //        .onChange(of: self.editMode.unsafelyUnwrapped) { mode in
        //
        //        }
        .onChange(of: editMode!.wrappedValue, perform: { value in
            if value.isEditing {
                // Entering edit mode (e.g. 'Edit' tapped)
            } else {
                // Leaving edit mode (e.g. 'Done' tapped)
                Task {
                    print("BEFORE AWAIT INTENT TO UPDATERECIPEEXECUTION")
                    await self.intent.intentToUpdateRecipeExecution(self.viewModel.model)
                    print("AFTER AWAIT INTENT TO UPDATERECIPEEXECUTION")
                }
            }
        })
    }
}

struct RecipeExecutionDetails_Previews: PreviewProvider {
    static var previews: some View {
        RecipeExecutionSteps(viewModel: RecipeExecutionStepsViewModel(model: MockData.executionPates), intent: RecipeIntent())
    }
}
