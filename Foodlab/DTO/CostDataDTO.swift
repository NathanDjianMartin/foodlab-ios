import Foundation

struct CostDataDTO: Identifiable, Codable {
    
    var id: Int?
    var averageHourlyCost: StringOrDouble
    var flatrateHourlyCost: StringOrDouble
    var coefWithCharges: StringOrDouble
    var coefWithoutCharges: StringOrDouble
    
    internal init(id: Int? = nil, averageHourlyCost: StringOrDouble, flatrateHourlyCost: StringOrDouble, coefWithCharges: StringOrDouble, coefWithoutCharges: StringOrDouble) {
        self.id = id
        self.averageHourlyCost = averageHourlyCost
        self.flatrateHourlyCost = flatrateHourlyCost
        self.coefWithCharges = coefWithCharges
        self.coefWithoutCharges = coefWithoutCharges
    }
    
}
