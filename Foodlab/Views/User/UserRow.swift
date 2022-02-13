import Foundation
import SwiftUI

struct UserRow: View {
    var user: User
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                Text(user.email)
                    .font(.caption)
            }
            if user.isAdmin {
                Spacer()
                Badge(text: "Admin")
            }
            Spacer()
            Button(action: {
                print("TODO: show confirmation modal")
            }) {
                Image(systemName: "square.and.pencil")
                    .padding(4)
                    .foregroundColor(Color.foodlabTeal)
            }
        }
        .padding()
    }
}

struct UserRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UserRow(user: MockData.user)
                .previewLayout(.fixed(width: 300, height: 70))
            
            UserRow(user: MockData.user)
                .previewLayout(.fixed(width: 300, height: 70))
                .preferredColorScheme(.dark)
        }
    }
}
