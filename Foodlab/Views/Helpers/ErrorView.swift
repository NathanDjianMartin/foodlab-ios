import SwiftUI

struct ErrorView: View {
    
    @Binding var error: String?
    
    var body: some View {
        if let error = error {
            withAnimation {
                HStack {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.leading)
                    Spacer()
                    Button {
                        self.error = nil
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                    }
                }
                .padding(3)
                .background {
                    RoundedRectangle(cornerRadius: 3)
                        .foregroundColor(.red)
                        .opacity(0.2)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(.red)
                }
                .padding()
                .transition(.scale)
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: .constant("Error in this view. Please fix error."))
    }
}
