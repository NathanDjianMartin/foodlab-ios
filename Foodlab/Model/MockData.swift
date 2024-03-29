import Foundation
import SwiftUI

struct MockData {
    
    //Ingredients
    static let ingredient = Ingredient(name: "Pommes",
                                       unit: "KG",
                                       unitaryPrice: 0.81,
                                       stockQuantity: 17.5,
                                       ingredientCategory: legume)
    
    static let allergenIngredient = Ingredient(name: "Farine de blé",
                                       unit: "KG",
                                       unitaryPrice: 0.54,
                                       stockQuantity: 4.3,
                                       ingredientCategory: legume,
                                       allergenCategory: crustace)
    
    static var ingredientList: [Ingredient] {
        var list: [Ingredient] = []
        for i in 1...15 {
            if [3, 6, 9].contains(i) {
                list.append(allergenIngredient)
            } else {
                list.append(ingredient)
            }
        }
        return list
    }
    
    static let fruitsLegumesCategory = Category(id: 21, name: "Fruits et légumes")
    static let epicerieCategory = Category(id: 11, name: "Épicerie")
    static let cremerieCategory = Category(id: 18, name: "Crèmerie")
    
    static let ingredientCategories = [fruitsLegumesCategory, epicerieCategory, cremerieCategory]
    
    static let glutenCategory = Category(id: 3, name: "Gluten")
    static let arachideCategiry = Category(id: 9, name: "Arachide")
    static let fruitsCoqueCategory = Category(id: 12, name: "Fruits à coque")
    static let allergenCategories = [glutenCategory, arachideCategiry, fruitsCoqueCategory]
    
    //Users
    static let user = User(name: "Ruby", email: "ruby@gmail.com", password: "ruby", isAdmin: true)
    static let usersList = [User](repeating: user, count: 6)
    
    //IngredientCategories
    static let legume = Category(id: 1, name: "Légume")
    static let crustace = Category(id: 2, name: "Crustacé")
    
    // Recipe Categories
    static let entree = Category(id: 2, name: "Entrée")
    static let dessert = Category(id: 1, name: "Dessert")
    static let plat = Category(id: 3, name: "Plat")
    
    static let ingredientCategoriesModel = [Category](repeating: legume, count: 3)
    static let allergenCategoriesModel = [Category](repeating: crustace, count: 2)
    static let recipeCategoriesModel = [entree, dessert, plat]
    
    //Cost data
    static let costData = CostData(id: 1, averageHourlyCost: 7.0, flatrateHourlyCost: 8.0, coefWithCharges: 4.2, coefWithoutCharges: 5.6)
    
    //Recipes
    
    // Pates
    static var executionPates: RecipeExecution {
        let execution = RecipeExecution(id: 2, title: "Pâtes exec")
        execution.addStep(step)
        execution.addStep(step2)
        execution.addStep(executionCrepes)
        return execution
    }
    
    static var recipePates: Recipe {
        let recipe = Recipe(id: 1, title: "Pates", author: "Nathan", guestsNumber: 3, recipeCategory: entree, costData: costData, execution: executionPates, duration: 0)
        return recipe
    }
    
    // Crepes
    
    static var executionCrepes: RecipeExecution {
        let execution = RecipeExecution(id: 1, title: "Crêpe exec")
        execution.addStep(step3)
        //execution.addStep(executionPates)
        execution.addStep(step4)
        return execution
    }
    
    
    static var recipeCrepes: Recipe {
        let recipe = Recipe(id: 1, title: "Crêpe", author: "Nathan", guestsNumber: 3, recipeCategory: entree, costData: costData, execution: executionCrepes, duration: 0)
        return recipe
    }
    
    //Step
    static let ingredientWithinStep = IngredientWithinStep(id: 1, ingredient: ingredient, quantity: 2)
    
    static let step = SimpleStep(id: 3, title: "Faire bouillir l'eau", stepDescription: "Remplir un récipient d'eau et amener le récipient au dessus d'une source de chaleur", duration: 10, ingredients: [ingredient: 2])
    static let step2 = SimpleStep(id: 4, title: "Égouter les pates", stepDescription: "Verser le contenu du récipient dans une passoire", duration: 1)
    
    static let step3 = SimpleStep(id: 5, title: "Mettre farine", stepDescription: "Mettre la farine et creuser un puit au milieu (comme un volcan)", duration: 2)
    static let step4 = SimpleStep(id: 6, title: "Casser les oeufs", stepDescription: "Casser les oeufs et les disposer au centre du puit de farine", duration: 1)
    
    static var recipeList: [Recipe] {
        return [recipeCrepes]
    }
    
}
