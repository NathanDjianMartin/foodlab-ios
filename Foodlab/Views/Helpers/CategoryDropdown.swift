import SwiftUI

struct CategoryDropdown: View {
    @State var value = ""
    var placeholder: String
    var dropDownList: [String]
    var body: some View {
        Menu {
            ForEach(dropDownList, id: \.self) { client in
                Button(client) {
                    self.value = client
                }
            }
        } label: {
            HStack{
                Text(value.isEmpty ? placeholder : value)
                    .foregroundColor(value.isEmpty ? .secondary : .primary)
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(Color.gray)
                    .font(Font.system(size: 20, weight: .medium))
            }
            .padding(5)
        }
    }
}

struct Dropdown_Previews: PreviewProvider {
    static var previews: some View {
        CategoryDropdown(placeholder: "Select a category", dropDownList: MockData.ingredientCategories)
    }
}
