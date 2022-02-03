import SwiftUI

struct Authentication: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                Image("login-bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
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
                        print("TODO: login")
                    }
                    .buttonStyle(DarkRedButtonStyle())
                }
                .frame(maxWidth: geometry.size.width - 100)
                .padding()
                .background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 10)
                )
            }
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
