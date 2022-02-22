import SwiftUI

struct SimpleStepRow: View {
    var step: SimpleStep
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                StepIndexCircle(stepNumber: 1)
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
        SimpleStepRow(step: MockData.step)
    }
}
