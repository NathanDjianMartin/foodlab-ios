import SwiftUI

struct Badge: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundColor(.white)
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.foodlabRed)
            )
    }
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Badge(text: "Badge")
                .previewLayout(.fixed(width: 60, height: 30))
            Badge(text: "Badge")
                .previewLayout(.fixed(width: 60, height: 30))
                .preferredColorScheme(.dark)
        }
    }
}
