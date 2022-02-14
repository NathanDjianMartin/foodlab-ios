import SwiftUI

struct Authentication: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        
        VStack {
            Spacer()
            VStack {
                Text("Welcome")
                    .font(.title)
                    .fontWeight(.bold)
                    .gradientForeground(colors: [.foodlabRed, .foodlabRed])
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedTextFieldStyle(color: .foodlabRed))
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedTextFieldStyle(color: .foodlabRed))
                Button("Login") {
                    withAnimation(.easeOut(duration: 0.5)) {
                        print("TODO: loginnnnn")
                        self.isAuthenticated = true
                    }
                }
                .buttonStyle(DarkRedButtonStyle())
                
            }
            .frame(maxWidth: 400)
            Spacer()
        }
        .padding()
    }
}

struct Authentication_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Authentication(isAuthenticated: .constant(false))
            Authentication(isAuthenticated: .constant(true))
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
