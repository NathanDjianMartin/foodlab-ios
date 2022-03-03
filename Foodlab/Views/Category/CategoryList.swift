import SwiftUI

struct CategoryList: View {
    
    @ObservedObject var categoryVM: CategoryViewModel
    
    var body: some View {
        VStack {
            HStack {
                TextField("Add category", text: $categoryVM.name)
                Button {
                    Task {
                        await categoryVM.create()
                    }
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
                ForEach(categoryVM.categories) { category in
                    Text(category.name)
                }
            }
            .onAppear {
                Task{
                    if categoryVM.categories.count == 0 {
                        switch  await CategoryDAO.getAllCategories(type: categoryVM.type) {
                        case .failure(let error):
                            print(error)
                            break
                        case .success(let categories):
                            self.categoryVM.categories = categories
                            print(self.categoryVM.categories)
                        }
                    }
                }
            }
            
        }.navigationTitle("Categories")
        
    }
}

struct CategoryList_Previews: PreviewProvider {
    static var previews: some View {
        CategoryList(categoryVM: CategoryViewModel(categories: MockData.ingredientCategoriesModel, type: CategoryType.ingredient))
    }
}
