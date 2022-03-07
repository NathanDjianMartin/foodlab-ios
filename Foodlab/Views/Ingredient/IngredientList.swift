import SwiftUI

struct IngredientList: View {
    
    @State private var showAlert = false
    @State private var selectedIngredient: Ingredient? = nil
    @State private var ingredientToDelete: Ingredient?
    @ObservedObject var viewModel: IngredientListViewModel
    private var intent: IngredientIntent
    
    @State private var searchText: String = ""
    @State private var selectedCategory: Category?
    @State private var ingredientCategories: [Category] = []
    
    var ingredientList: [Ingredient] {
        var result: [Ingredient] = self.viewModel.ingredients
        
        if let selectedCategory = selectedCategory {
            result = result.filter { ingredient in
                if ingredient.ingredientCategory.id == selectedCategory.id {
                    return true
                } else if let allergenCategory = ingredient.allergenCategory {
                    return allergenCategory.id == selectedCategory.id
                } else {
                    return false
                }
            }
        }
        
        if searchText.count > 0 {
            result = result.filter { ingredient in
                ingredient.name.contains(searchText)
            }
        }
        
        return result
    }
    
    init() {
        self.viewModel = IngredientListViewModel()
        self.intent = IngredientIntent()
        self.intent.addObserver(ingredientListViewModel: viewModel)
    }
    
    private func fetchData() async {
        switch  await IngredientDAO.shared.getAllIngredients() {
        case .failure(let error):
            DispatchQueue.main.async {
                self.viewModel.error = error.localizedDescription
            }
        case .success(let ingredients):
            DispatchQueue.main.async {
                self.viewModel.ingredients = ingredients
            }
            //self.viewModel.ingredients = ingredients
        }
        
        switch await CategoryDAO.shared.getAllCategories(type: .ingredient) {
        case .success(let categories):
            DispatchQueue.main.async {
                self.ingredientCategories = categories
            }
        case .failure(let error):
            DispatchQueue.main.async {
                self.viewModel.error = error.localizedDescription
            }
        }
    }
    
    var body: some View {
        
        VStack {
            MessageView(message: $viewModel.error, type: TypeMessage.error)
            List {
//                if self.viewModel.ingredients.count <= 0 {
//                    VStack {
//                        ProgressView()
//                            .progressViewStyle(.circular)
//                        Text("We're gathering the ingredients 😬")
//                    }
//                }
                HStack {
                    Menu {
                        Button {
                            self.selectedCategory = nil
                        } label: {
                            Label("None", systemImage: "xmark")
                        }
                        ForEach(ingredientCategories) { category in
                            Button {
                                self.selectedCategory = category
                            } label: {
                                Text("\(category.name)")
                                Spacer()
                                if selectedCategory?.name == category.name {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    } label: {
                        Text(selectedCategory != nil ? selectedCategory!.name : "Select ingredient category")
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                }
                ForEach(Array(self.ingredientList.enumerated()), id: \.element.self) { ingredientIndex, ingredient in
                    IngredientRow(ingredientVM: IngredientFormViewModel(model: ingredient ))
                        .swipeActions {
                            Button {
                                self.showAlert = true
                                self.ingredientToDelete = ingredient
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.foodlabRed)
                            Button {
                                self.selectedIngredient = ingredient
                            } label: {
                                Image(systemName: "square.and.pencil")
                            }
                            .tint(.foodlabTeal)
                        }
                        .confirmationDialog("Delete ingredient?", isPresented: $showAlert) {
                            Button(role: .cancel) {
                            } label: {
                                Text("No")
                            }
                            Button(role: .destructive) {
                                guard let ingredientToDelete = ingredientToDelete else {
                                    return
                                }
                                guard let id = ingredientToDelete.id else {
                                    return
                                }
                                guard let indexToDelete = self.viewModel.ingredients.firstIndex(of: ingredientToDelete) else {
                                    return
                                }
                                self.showAlert = false
                                Task {
                                    await self.intent.intentToDelete(ingredientId: id, ingredientIndex: indexToDelete)
                                }
                            } label: {
                                Text("Yes")
                            }
                        }
                }
            }
            .searchable(text: $searchText)
            .refreshable {
                Task {
                    await self.fetchData()
                }
            }
            .onAppear {
                Task{
                    if viewModel.ingredients.count == 0 {
                        await self.fetchData()
                    }
                }
            }
            .sheet(item: self.$selectedIngredient) { ingredient in
                IngredientForm(ingredientVM: IngredientFormViewModel(model: ingredient), intent: self.intent, isPresented: $selectedIngredient)
                
            }
            .navigationTitle("Ingredients")
            .toolbar {
                Button(action: {
                    self.selectedIngredient = Ingredient(name: "", unit: "", unitaryPrice: 0, stockQuantity: 0, ingredientCategory: Category(name: ""))
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct StocksList_Previews: PreviewProvider {
    static var previews: some View {
        IngredientList()
        
    }
}
