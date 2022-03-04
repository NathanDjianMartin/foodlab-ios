import SwiftUI

struct CategoryList: View {
    
    
    @State private var showAlert = false
    @State private var categoryToDelete: Category?

    @ObservedObject var categoryVM: CategoryViewModel
    
    var body: some View {
        VStack {
            
            MessageView(message: $categoryVM.error, type: TypeMessage.error)
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
                        .swipeActions {
                            Button {
                                self.showAlert = true
                                self.categoryToDelete = category
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.foodlabRed)
                        }
                        .confirmationDialog("Delete category?", isPresented: $showAlert) {
                            Button(role: .cancel) {
                            } label: {
                                Text("No")
                            }
                            Button(role: .destructive) {
                                guard let categoryToDelete = categoryToDelete else {
                                    return
                                }
                                guard let id = categoryToDelete.id else {
                                    return
                                }
                                guard let indexToDelete = self.categoryVM.categories.firstIndex(of: categoryToDelete) else {
                                    return
                                }
                                self.showAlert = false
                                Task {
                                    await self.categoryVM.delete(categoryId: id, categoryIndex: indexToDelete)
                                }
                            } label: {
                                Text("Yes")
                            }
                        }
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
