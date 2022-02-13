import SwiftUI

struct CategoryList: View {
    var categories: [Category]
    var body: some View {
        List {
            ForEach(categories) { category in
                Text(category.name)
            }
        }
    }
}

struct CategoryList_Previews: PreviewProvider {
    static var previews: some View {
        CategoryList(categories: MockData.ingredientCategoriesModel)
    }
}
