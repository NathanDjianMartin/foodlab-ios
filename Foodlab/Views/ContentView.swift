import SwiftUI

struct ContentView: View {
    @State var isAuthenticated: Bool = true
    
    var body: some View {
        if isAuthenticated {
            MainView()
                .transition(.opacity)
        } else {
            Authentication(isAuthenticated: $isAuthenticated)
                .transition(.opacity)
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
