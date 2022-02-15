import SwiftUI

struct RecipeCreation: View {
    @State private var recipeName: String = ""
    @State private var authorName: String = ""
    @State private var guestNumber: Int = 1
    @Binding var isPresented: Bool
    
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
            
            HStack {
                Text("Recipe creation")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding()
            
            List {
                TextField("Recipe name", text: $recipeName)
                TextField("Author", text: $authorName)
                Stepper(value: $guestNumber) {
                    Text("For \(guestNumber) guest\(guestNumber > 1 ? "s" : "")")
                }
            }
            .listStyle(.plain)
        }
    }
}

struct RecipeCreation_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCreation(isPresented: .constant(true))
    }
}
