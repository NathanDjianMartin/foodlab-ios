import Foundation

enum CategoryType : String {
    case ingredient = "ingredient-category"
    case allergen = "allergen-category"
    case recipe = "recipe-category"
}

struct CategoryDAO {
    // MARK: singleton conformance
    
    static var shared: CategoryDAO = {
        return CategoryDAO()
    }()
    
    private init() {}
        
    // Ingredient
    func getAllIngredientCategories() async -> Result<[Category], Error> {
        return await getAllCategories(type: CategoryType.ingredient )
    }
    
    func getIngredientCategoryById(id: Int) async -> Result<Category, Error> {
        return await getCategoryById(type: CategoryType.ingredient, id: id)
    }
    
    func createIngredientCategory(category: Category) async -> Result<Category, Error> {
        return await createCategory(type: CategoryType.ingredient, category: category)
    }
    
    // Allergen
    func getAllAllergenCategories() async -> Result<[Category], Error> {
        return await getAllCategories(type: CategoryType.allergen )
    }
    
    func getAllergenCategoryById(id: Int) async -> Result<Category, Error> {
        return await getCategoryById(type: CategoryType.allergen, id: id)
    }
    
    func createAllergenCategory(category: Category) async -> Result<Category, Error> {
        return await createCategory(type: CategoryType.allergen, category: category)
    }
    
    // Recipe
    func getAllRecipeCategories() async -> Result<[Category], Error> {
        return await getAllCategories(type: CategoryType.recipe )
    }
    
    func getRecipeCategoryById(id: Int) async -> Result<Category, Error> {
        return await getCategoryById(type: CategoryType.recipe, id: id)
    }
    
    func createRecipeCategory(category: Category) async -> Result<Category, Error> {
        return await createCategory(type: CategoryType.recipe, category: category)
    }
    
    // General
    
    func getAllCategories(type: CategoryType) async -> Result<[Category], Error> {
        do {
            // recupere tout les ingredients de la base de donnee et les transforment en IngredientDTO
            let decoded : [CategoryDTO] = try await URLSession.shared.get(from: FoodlabApp.apiUrl + "\(type.rawValue)")
            
            // dans une boucle transformer chaque UserDTO en model User
            var categories: [Category] = []
            for categoryDTO in decoded {
                categories.append(getCategoryFromCategoryDTO(categoryDTO: categoryDTO))
            }
            
            // retourner une liste de User
            return .success(categories)
            
        } catch {
            return .failure(error)
        }
    }
    
    func getCategoryById(type: CategoryType, id: Int) async -> Result<Category, Error> {
        do {
            // recupere tout les ingredients de la base de donnee et les transforment en IngredientDTO
            let decoded : CategoryDTO = try await URLSession.shared.get(from: FoodlabApp.apiUrl + "\(type.rawValue)/\(id)")
            
            // retourne Result avec Category ou Error
            return .success(getCategoryFromCategoryDTO(categoryDTO: decoded))
            
        } catch {
            print("Error while fetching ingredient from backend: \(error)")
            return .failure(error)
        }
    }
    
    func createCategory(type: CategoryType, category: Category) async -> Result<Category, Error> {
        let categoryDTO = getCategoryDTOFromCategory(category: category)
        do {
            let categoryDTOresult : CategoryDTO = try await URLSession.shared.create(from: FoodlabApp.apiUrl + "\(type.rawValue)", object: categoryDTO)
            return .success(getCategoryFromCategoryDTO(categoryDTO: categoryDTOresult))
        }catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
    }
    
    func deleteCategoryById(type: CategoryType, id: Int) async -> Result<Bool, Error> {
        do {
            let deleted: Bool = try await URLSession.shared.delete(from: FoodlabApp.apiUrl + "\(type.rawValue)/\(id)")
            return .success(deleted)
        } catch {
            return .failure(error)
        }
    }
    
    private func getCategoryDTOFromCategory(category: Category) -> CategoryDTO {
        let categoryDTO = CategoryDTO(
            id: category.id,
            name: category.name
        )
        return categoryDTO
    }
    
    private func getCategoryFromCategoryDTO(categoryDTO : CategoryDTO) -> Category {
        //TODO : gérer catégorie ingrédient et allergen
        let category = Category(
            id: categoryDTO.id,
            name: categoryDTO.name
        )
        return category
    }
    
    
}
