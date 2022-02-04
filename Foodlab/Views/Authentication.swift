import SwiftUI

struct Authentication: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isAuthenticated = false
    
    var body: some View {
        
        NavigationView {
            VStack {
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
                    NavigationLink(destination: IngredientCreation(), isActive: $isAuthenticated) {
                        EmptyView()
                    }
                }
                .padding()
                .background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 10)
                )
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
}

struct Authentication_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Authentication()
            Authentication()
                .previewInterfaceOrientation(.landscapeLeft)
                .preferredColorScheme(.dark)
        }
    }
}
