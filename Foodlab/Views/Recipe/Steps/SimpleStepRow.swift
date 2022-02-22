import SwiftUI

struct SimpleStepRow: View {
    var step: SimpleStep
    var index: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                StepIndexCircle(stepNumber: index)
                Text(step.title)
                    .bold()
                Spacer()
            }
            Text(step.description)
        }
        .padding()
    }
}

struct SimpleStepRow_Previews: PreviewProvider {
    static var previews: some View {
        SimpleStepRow(step: MockData.step, index: 1)
    }
}
