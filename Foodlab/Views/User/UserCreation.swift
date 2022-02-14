import SwiftUI

struct UserCreation: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isAdmin: Bool = false
    @Binding var isPresented: Bool
    
    var columns = [GridItem(.adaptive(minimum: 300))]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.isPresented = false
                }) {
                    Text("Cancel")
                }
            }
            .padding()
            List {
                HStack {
                    Text("Name")
                    Divider()
                    TextField("Name", text: $name)
                }
                
                HStack {
                    Text("Email")
                    Divider()
                    TextField("Email", text: $email)
                }
                
                HStack {
                    Text("Password")
                    Divider()
                    TextField("Password", text: $password)
                }
                
                HStack {
                    Text("Admin")
                    Toggle(isOn: $isAdmin) {
                        
                    }
                }
                
                HStack {
                    Spacer()
                    Button("Create user") {
                        print("TODO: Create ingredient!")
                    }
                    .buttonStyle(DarkRedButtonStyle())
                }
            }
            .listStyle(.plain)
            .padding()
        }
    }
}

struct UserCreation_Previews: PreviewProvider {
    static var previews: some View {
        UserCreation(isPresented: .constant(true))
    }
}
