import SwiftUI

struct IngredientList: View {
    
    @State private var showAlert = false
    @State private var selectedIngredient: Ingredient? = nil
    @State private var ingredientToDelete: Ingredient?
    @ObservedObject var viewModel: IngredientListViewModel
    private var intent: IngredientIntent
    
    init() {
        self.viewModel = IngredientListViewModel()
        self.intent = IngredientIntent()
        self.intent.addObserver(ingredientListViewModel: viewModel)
    }
    
    var body: some View {
        
        VStack {
            MessageView(message: $viewModel.error, type: TypeMessage.error)
            List {
                if self.viewModel.ingredients.count <= 0 {
                    VStack {
                        ProgressView()
                            .progressViewStyle(.circular)
                        Text("We're gathering the ingredients 😬")
                    }
                }
                ForEach(Array(viewModel.ingredients.enumerated()), id: \.element.self) { ingredientIndex, ingredient in
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
            .onAppear {
                Task{
                    if viewModel.ingredients.count == 0 {
                        switch  await IngredientDAO.getAllIngredients() {
                        case .failure(let error):
                            print(error)
                            break
                        case .success(let ingredients):
                            self.viewModel.ingredients = ingredients
                            //print(self.viewModel.ingredients)
                        }
                    }
                }
            }
            .sheet(item: self.$selectedIngredient) { ingredient in
                IngredientForm(ingredientVM: IngredientFormViewModel(model: ingredient), intent: self.intent, isPresented: $selectedIngredient)
                
            }
            .navigationTitle("Ingredients")
            .toolbar {
                Button(action: {
                    self.selectedIngredient = Ingredient(name: "Name", unit: "Unit", unitaryPrice: 0, stockQuantity: 0, ingredientCategory: Category(id: 19, name: ""))
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
