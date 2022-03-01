import SwiftUI

struct CategoryDropdown: View {
    @State var selectedCategory: Category?
    var placeholder: String
    var dropDownList: [Category]
    var canBeEmpty: Bool
    
    init(selectedCategory: Category? = nil, placeholder: String = "Select element", dropDownList: [Category], canBeEmpty: Bool = true) {
        self.selectedCategory = selectedCategory
        self.placeholder = placeholder
        self.dropDownList = dropDownList
        self.canBeEmpty = canBeEmpty
    }
    
    var body: some View {
        Menu {
            if canBeEmpty {
                Button("None") {
                    self.selectedCategory = nil
                }
            }
            ForEach(dropDownList, id: \.self) { category in
                Button {
                    self.selectedCategory = category
                } label: {
                    HStack {
                        Text(category.name)
                        if selectedCategory == category {
                            Image(systemName: "checkmark")
                        }
                    }
                }

            }
        } label: {
            HStack{
                if let selectedCategory = selectedCategory {
                    Text(selectedCategory.name)
                        .foregroundColor(.primary)
                } else {
                    Text(placeholder)
                        .foregroundColor(.secondary)
                }
                
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
        CategoryDropdown(placeholder: "Select a category", dropDownList: MockData.ingredientCategories, canBeEmpty: true)
    }
}
