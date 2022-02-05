import SwiftUI

struct ContentView: View {
    @State var isAuthenticated: Bool = false
    
    var body: some View {
        if isAuthenticated {
            MainView()
        } else {
            Authentication(isAuthenticated: $isAuthenticated)
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
