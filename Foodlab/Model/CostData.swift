import Foundation


protocol CostDataObserver {
    
    func changed(averageHourlyCost: Double)
    func changed(flatrateHourlyCost: Double)
    func changed(coefWithCharges: Double)
    func changed(coefWithoutCharges: Double)
    
}

class CostData: Identifiable {
    
    var observer: CostDataObserver?
    
    var id: Int?
    var averageHourlyCost: Double {
        didSet {
            self.observer?.changed(averageHourlyCost: self.averageHourlyCost) // this call makes possible observer to observe
        }
    }
    var flatrateHourlyCost: Double {
        didSet {
            self.observer?.changed(flatrateHourlyCost: self.flatrateHourlyCost) // this call makes possible observer to observe
        }
    }
    var coefWithCharges: Double {
        didSet {
            self.observer?.changed(coefWithCharges: self.coefWithCharges) // this call makes possible observer to observe
        }
    }
    var coefWithoutCharges: Double {
        didSet {
            self.observer?.changed(coefWithoutCharges: self.coefWithoutCharges) // this call makes possible observer to observe
        }
    }
    
    internal init(id: Int? = nil, averageHourlyCost: Double, flatrateHourlyCost: Double, coefWithCharges: Double, coefWithoutCharges: Double) {
        self.id = id
        self.averageHourlyCost = averageHourlyCost
        self.flatrateHourlyCost = flatrateHourlyCost
        self.coefWithCharges = coefWithCharges
        self.coefWithoutCharges = coefWithoutCharges
    }
    
}
