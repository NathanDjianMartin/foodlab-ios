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
    
    static let ingredientList = [Ingredient](repeating: ingredient, count: 20)
    
    static let ingredientCategories = ["Féculent", "Légume", "Fruit", "Produit laitier"]
    static let allergenCategories = ["Gluten", "Céréale", "Crustacé"]
    
    //Users
    static let user = User(name: "Ruby", email: "ruby@gmail.com", password: "ruby", isAdmin: true)
    static let usersList = [User](repeating: user, count: 6)
}
