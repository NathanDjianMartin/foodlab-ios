import Foundation

struct MockData {
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
    static let ingredientCategories = ["Féculent", "Légume", "Fruit", "Produit laitier"]
    static let allergenCategories = ["Gluten", "Céréale", "Crustacé"]
}
