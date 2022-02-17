import SwiftUI

struct CategoryList: View {
    var categories: [Category]
    @State var name = ""
    var body: some View {
        VStack {
            HStack {
                TextField("Add category", text: $name)
                Button {
                    print("TODO: Create ingredient!")
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.foodlabRed)
                        .font(.title2)
                }
                //.buttonStyle(DarkRedButtonStyle())
            }
            .padding(.leading, 30)
            .padding(.trailing, 30)
            .padding(.top, 20)
              
            List {
                ForEach(categories) { category in
                    Text(category.name)
                }
            }
            
        }.navigationTitle("Categories")
        
    }
}

struct CategoryList_Previews: PreviewProvider {
    static var previews: some View {
        CategoryList(categories: MockData.ingredientCategoriesModel)
    }
}
