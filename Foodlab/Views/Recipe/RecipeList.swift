import SwiftUI

struct RecipeList: View {
    @State private var showRecipeCreation = false
    @State private var searchText = ""
    @State private var recipeList: [Recipe] = []
    @State private var error: Error?
    @State private var appearCount = 0 // until Apple fixes the onAppear that is called twice
    
    var body: some View {
        
        VStack {
            //Text(searchText)
            if let error = error {
                Text(error.localizedDescription)
                    .foregroundColor(.red)
            }
            List {
                ForEach(recipeList) { recipe in
                    NavigationLink {
                        RecipeDetails(recipe: recipe)
                    } label: {
                        RecipeRow(viewModel: RecipeRowViewModel(model: recipe))
                    }
                }
                //                ForEach(MockData.recipeCategoriesModel) { category in
                //                    Section(category.name) {
                //                        ForEach(1..<3) { number in
                //                            NavigationLink {
                //                                RecipeDetails(recipe: MockData.recipePates)
                //                            } label: {
                //                                RecipeRow(recipe: MockData.recipePates)
                //                            }
                //                        }
                //                    }
                //                }
            }
            .searchable(text: $searchText, prompt: "Search a recipe")
            .sheet(isPresented: $showRecipeCreation) {
                let newRecipe = Recipe(title: "", author: "", guestsNumber: 1, recipeCategory: MockData.entree, costData: MockData.costData, execution: RecipeExecution(title: ""))
                RecipeForm(viewModel: RecipeFormViewModel(model: newRecipe), isPresented: $showRecipeCreation)
            }
        }
        .navigationTitle("Recipes")
        .toolbar {
            Button(action: {
                self.showRecipeCreation = true
            }) {
                Image(systemName: "plus")
            }
        }
        .onAppear {
            if appearCount == 0 {
                Task {
                    switch await RecipeDAO.shared.getRecipeById(47) {
                    case .success(let recipe):
                        self.recipeList.append(recipe)
                    case .failure(let error):
                        self.error = error
                    }
                }
                appearCount += 1
            }
        }
        //        .overlay {
        //            VStack {
        //                Spacer()
        //                HStack {
        //                    Spacer()
        //                    Button(action: {
        //                        self.showRecipeCreation = true
        //                    }) {
        //                        RoundedRectangle(cornerRadius: 10)
        //                            .frame(width: 50, height: 50)
        //                            .foregroundColor(.foodlabRed)
        //                            .overlay {
        //                                Image(systemName: "plus")
        //                                    .foregroundColor(.white)
        //                                    .font(.title)
        //                            }
        //                    }
        //                }
        //            }
        //            .padding()
        //        }
    }
}

struct RecipesList_Previews: PreviewProvider {
    static var previews: some View {
        RecipeList()
            .preferredColorScheme(.dark)
    }
}
