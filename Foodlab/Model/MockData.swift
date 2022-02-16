import Foundation

struct MockData {
    
    //Ingredients
    static let ingredient = Ingredient(name: "Pommes",
                                       unit: "KG",
                                       price: 0.81,
                                       stockQuantity: 17.5,
                                       ingredientCategory: ingredientCategories[2])
    
    static let allergenIngredient = Ingredient(name: "Farine de blé",
                                       unit: "KG",
                                       price: 0.54,
                                       stockQuantity: 4.3,
                                       ingredientCategory: ingredientCategories[0],
                                       allergenCategory: allergenCategories[0])
    
    static let ingredientList = [Ingredient](repeating: ingredient, count: 5)
    
    static let ingredientCategories = ["Féculent", "Légume", "Fruit", "Produit laitier"]
    static let allergenCategories = ["Gluten", "Céréale", "Crustacé"]
    
    //Users
    static let user = User(name: "Ruby", email: "ruby@gmail.com", password: "ruby", isAdmin: true)
    static let usersList = [User](repeating: user, count: 6)
    
    //IngredientCategories
    static let legume = Category(id: 1, name: "Légume")
    static let crustace = Category(id: 1, name: "Crustacé")
    static let entree = Category(id: 1, name: "Entrée")
    
    static let ingredientCategoriesModel = [Category](repeating: legume, count: 3)
    static let allergenCategoriesModel = [Category](repeating: crustace, count: 2)
    static let recipeCategoriesModel = [Category](repeating: entree, count: 2)
    
    
}
