import SwiftUI

enum TypeMessage {
    case error
    case success
}

struct MessageView: View {
    
    @Binding var message: String?
    var type: TypeMessage
    
    var body: some View {
        if let message = message {
            withAnimation {
                HStack {
                    switch self.type {
                    case .error:
                        Text(message)
                            .foregroundColor(.red)
                            .padding(.leading)
                    case .success:
                        Text(message)
                            .foregroundColor(.green)
                            .padding(.leading)
                    }
                    
                    Spacer()
                    Button {
                        self.message = nil
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
        MessageView(message: .constant("Error in this view. Please fix error."), type: TypeMessage.error)
    }
}
