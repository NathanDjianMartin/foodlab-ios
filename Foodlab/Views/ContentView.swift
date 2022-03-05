import SwiftUI

struct ContentView: View {
    @StateObject var loggedUser: LoggedUser = LoggedUser(name: "", email: "", isAdmin: false, isAuthenticated: false)
    
    var body: some View {
        if loggedUser.isAuthenticated {
            MainView()
                .transition(.opacity)
                .environmentObject(loggedUser)
        } else {
            Authentication()
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
