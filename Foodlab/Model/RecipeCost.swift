import Foundation

class RecipeCost {
    var costData: CostData
    var ingredientCost: Double
    var recipeDuration: Int
        
    var materialCost: Double {
        ingredientCost + (ingredientCost * 0.05)
    }
    var salesPricesWithoutCharges: Double {
        materialCost * costData.coefWithoutCharges
    }
    var staffCost: Double {
        (Double(recipeDuration)/60) * costData.averageHourlyCost
    }
    var fluidCost: Double {
        (Double(recipeDuration)/60) * costData.flatrateHourlyCost
    }
    var chargesCost: Double {
        staffCost + fluidCost
    }
    var productionCost: Double {
        materialCost + chargesCost
    }
    var salesPriceWithCharges: Double {
        productionCost * costData.coefWithCharges
    }
    var portionProfit: Double {
        salesPriceWithCharges - productionCost
    }
    
    init(costData: CostData, ingredientCost: Double, recipeDuration: Int){
        self.costData = costData
        self.ingredientCost = ingredientCost
        self.recipeDuration = recipeDuration
    }
    
}
