import SwiftUI

struct ContentView: View {
    @State var isAuthenticated: Bool = false
    @StateObject var loggedUser: LoggedUser = LoggedUser(name: "", email: "", isAdmin: false)
    
    var body: some View {
        if isAuthenticated {
            MainView()
                .transition(.opacity)
                .environmentObject(loggedUser)
        } else {
            Authentication(isAuthenticated: $isAuthenticated)
                .transition(.opacity)
                .environmentObject(loggedUser)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
