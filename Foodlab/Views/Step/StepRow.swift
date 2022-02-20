import SwiftUI

struct StepRow: View {
    var step: SimpleStep
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(step.title)
                    .font(.headline)
                Text(step.description)
                    .font(.caption)
            }
            Spacer()
            // TODO: manage deletion with a swipe
        }
        .padding()
    }
}

struct StepRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StepRow(step: MockData.step)
                .previewLayout(.fixed(width: 300, height: 70))
            
        }
    }
}
