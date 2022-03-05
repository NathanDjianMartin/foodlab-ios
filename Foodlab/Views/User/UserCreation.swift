import SwiftUI

struct UserCreation: View {
    
    @Binding var isPresented: User?
    @ObservedObject var viewModel: UserFormViewModel
    private var intent: UserIntent
    
    init(userVM: UserFormViewModel, intent: UserIntent, isPresented: Binding<User?>){
        self.viewModel = userVM
        self._isPresented = isPresented
        self.intent = intent
        self.intent.addObserver(userFormViewModel: userVM)
    }
    
    var columns = [GridItem(.adaptive(minimum: 300))]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.isPresented = nil
                }) {
                    Text("Cancel")
                }
            }
            .padding()
            MessageView(message: $viewModel.error, type: TypeMessage.error)
            List {
                HStack {
                    Text("Name")
                    Divider()
                    TextField("Name", text: $viewModel.name)
                        .onSubmit {
                            intent.intentToChange(name: viewModel.name)
                        }
                }
                
                HStack {
                    Text("Email")
                    Divider()
                    TextField("Email", text: $viewModel.email)
                        .onSubmit {
                            intent.intentToChange(email: viewModel.email)
                        }
                }
                
                HStack {
                    Text("Password")
                    Divider()
                    SecureField("Password", text: $viewModel.password)
                        .onSubmit {
                            intent.intentToChange(password: viewModel.password)
                        }
                }
                
                HStack {
                    Text("Admin")
                    Toggle(isOn: $viewModel.isAdmin) {
                        
                    }.onSubmit {
                        intent.intentToChange(isAdmin: viewModel.isAdmin)
                    }
                }
                
                HStack {
                    Spacer()
                    Button("Create user") {
                        Task {
                            await intent.intentToCreate(user: viewModel.modelCopy)
                            if let error = viewModel.error {
                                
                            } else {
                                self.isPresented = nil
                            }
                            
                        }
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
        UserCreation(userVM: UserFormViewModel(model: MockData.user), intent: UserIntent(), isPresented: .constant(MockData.user))
    }
}
