import Foundation

class CostData: Identifiable {
    
    var id: Int?
    var averageHourlyCost: Double
    var flatrateHourlyCost: Double
    var coefWithCharges: Double
    var coefWithoutCharges: Double
    
    internal init(id: Int? = nil, averageHourlyCost: Double, flatrateHourlyCost: Double, coefWithCharges: Double, coefWithoutCharges: Double) {
        self.id = id
        self.averageHourlyCost = averageHourlyCost
        self.flatrateHourlyCost = flatrateHourlyCost
        self.coefWithCharges = coefWithCharges
        self.coefWithoutCharges = coefWithoutCharges
    }
    
}
