import SwiftUI

struct Authentication: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var isAuthenticated: Bool
    
    @EnvironmentObject var loggedUser: LoggedUser
    
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
                    //withAnimation(.easeOut(duration: 0.5)) {
                        Task {
                            switch await UserDAO.login(email: email, password: password) {
                            case .failure(let error):
                                print(error)
                            case .success(let isAuthenticated):
                                switch await UserDAO.getProfile() {
                                case .failure(let error):
                                    print(error)
                                case .success(let user):
                                    loggedUser.email = user.email
                                    loggedUser.name = user.name
                                    loggedUser.isAdmin = user.isAdmin
                                    self.isAuthenticated = isAuthenticated
                                }
                            }
                        }
                    //}
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
