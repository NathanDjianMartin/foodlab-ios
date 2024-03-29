import Foundation

struct IngredientDAO {
    // MARK: singleton conformance
    
    static var shared: IngredientDAO = {
        return IngredientDAO()
    }()
    
    private init() {}
        
    func getAllIngredients() async -> Result<[Ingredient], Error> {
        do {
            // recupere tout les ingredients de la base de donnee et les transforment en IngredientDTO
            let decoded : [IngredientDTO] = try await URLSession.shared.get(from: FoodlabApp.apiUrl + "ingredient")
            
            // dans une boucle transformer chaque IngredientDTO en model Ingredient
            var ingredients: [Ingredient] = []
            for ingredientDTO in decoded {
                switch await getIngredientFromIngredientDTO(ingredientDTO: ingredientDTO) {
                case .failure(let error):
                    return .failure(error)
                case .success(let ingredient):
                    ingredients.append(ingredient)
                }
            }
            
            // retourner une liste d'Ingredient
            return .success(ingredients)
            
        } catch {
            print("Error while fetching ingredients from backend: \(error)")
            return .failure(error)
        }
    }
    
    func getIngredientById(id: Int) async -> Result<Ingredient, Error> {
        do {
            
            // decoder le JSON avec la fonction présente dans JSONHelper
            let ingredientDTO : IngredientDTO = try await URLSession.shared.get(from: FoodlabApp.apiUrl + "ingredient/\(id)")
            
            // retourner un Result avec ingredient ou error
            return await getIngredientFromIngredientDTO(ingredientDTO: ingredientDTO)
            
        } catch {
            print("Error while fetching ingredient from backend: \(error)")
            return .failure(error)
        }
    }
    
    func updateIngredient(ingredient: Ingredient) async -> Result<Bool, Error> {
        let ingredientDTO = getIngredientDTOFromIngredient(ingredient: ingredient)
        do {
            // TODO: verifier id
            let isUpdated = try await URLSession.shared.update(from: FoodlabApp.apiUrl + "ingredient/\(ingredient.id!)", object: ingredientDTO)
            return .success(isUpdated)
        } catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
        
    }
    
    func createIngredient(ingredient: Ingredient) async -> Result<Ingredient, Error> {
        let ingredientDTO = getIngredientDTOFromIngredient(ingredient: ingredient)
        do {
            //TODO: verifier id
            let ingredientDTOresult : IngredientDTO = try await URLSession.shared.create(from: FoodlabApp.apiUrl + "ingredient", object: ingredientDTO)
            return await getIngredientFromIngredientDTO(ingredientDTO: ingredientDTOresult)
        } catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
        
    }
    
    private func getIngredientDTOFromIngredient(ingredient: Ingredient) -> IngredientDTO {
        //TODO: on suppose qu'il s'agit d'une modification pour l'instant donc il y a déjà les categories id juste pour faire un premier test
        if let allergen = ingredient.allergenCategory {
            return IngredientDTO(id: ingredient.id, name: ingredient.name, unit: ingredient.unit, unitaryPrice: .post(ingredient.unitaryPrice), stockQuantity: .post(ingredient.stockQuantity), ingredientCategoryId: ingredient.ingredientCategory.id!, allergenCategoryId: allergen.id!)
        } else {
            return IngredientDTO(id: ingredient.id, name: ingredient.name, unit: ingredient.unit, unitaryPrice: .post(ingredient.unitaryPrice), stockQuantity: .post(ingredient.stockQuantity), ingredientCategoryId: ingredient.ingredientCategory.id!, allergenCategoryId: nil)
        }
    }
    
    private func getIngredientFromIngredientDTO(ingredientDTO : IngredientDTO) async -> Result<Ingredient, Error> {
        // manage unitary price
        let unitaryPrice: Double
        switch ingredientDTO.unitaryPrice {
        case .post(let double):
            unitaryPrice = double
        case .get(let string):
            guard let double = Double(string) else {
                return .failure(ConversionError.stringToDouble)
            }
            unitaryPrice = double
        }
        
        // manage stock quantity
        let stockQuantity: Double
        switch ingredientDTO.stockQuantity {
        case .post(let double):
            stockQuantity = double
        case .get(let string):
            guard let double = Double(string) else {
                return .failure(ConversionError.stringToDouble)
            }
            stockQuantity = double
        }
        
        // manage ingredient category
        let ingredientCategory: Category
        switch await CategoryDAO.shared.getIngredientCategoryById(id: ingredientDTO.ingredientCategoryId){
        case .failure(let error):
            return .failure(error)
        case .success(let category):
            ingredientCategory = category
        }
        
        // manage ingredient category
        var allergenCategory: Category? = nil
        if let allergen = ingredientDTO.allergenCategoryId {
            switch await CategoryDAO.shared.getAllergenCategoryById(id: allergen){
            case .failure(let error):
                return .failure(error)
            case .success(let category):
                allergenCategory = category
            }
        }
        
        let ingredient = Ingredient(
            id: ingredientDTO.id,
            name: ingredientDTO.name,
            unit: ingredientDTO.unit,
            unitaryPrice: unitaryPrice,
            stockQuantity: stockQuantity,
            ingredientCategory: ingredientCategory,
            allergenCategory: allergenCategory
        )
        
        return .success(ingredient)
    }
    
    func deleteIngredientById(_ id: Int) async -> Result<Bool, Error> {
        do {
            let deleted: Bool = try await URLSession.shared.delete(from: FoodlabApp.apiUrl + "ingredient/\(id)")
            return .success(deleted)
        } catch {
            return .failure(error)
        }
    }
}
