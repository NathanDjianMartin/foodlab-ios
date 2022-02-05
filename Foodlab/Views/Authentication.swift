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
                    .foregroundColor(.white)
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedTextFieldStyle(color: .white))
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedTextFieldStyle(color: .white))
                Button("Login") {
                    print("TODO: loginnnnn")
                    self.isAuthenticated = true
                }
                .buttonStyle(DarkRedButtonStyle())
                
            }
            .padding()
            .background(
                .regularMaterial,
                in: RoundedRectangle(cornerRadius: 10)
            )
            .frame(maxWidth: 700)
            Spacer()
        }
        .padding()
        .background(
            Image("login-bg")
                .aspectRatio(contentMode: .fit)
                .ignoresSafeArea()
        )
        .ignoresSafeArea(.keyboard)
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
