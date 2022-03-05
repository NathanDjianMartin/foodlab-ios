import Foundation

struct CostDataDAO {
    // MARK: singleton conformance
    
    static var shared: CostDataDAO = {
        return CostDataDAO()
    }()
    
    private init() {}

    func getCostData(id: Int) async -> Result<CostData, Error> {
        do {
            // recupere tout les ingredients de la base de donnee et les transforment en IngredientDTO
            let decoded : CostDataDTO = try await URLSession.shared.get(from: FoodlabApp.apiUrl + "cost-data/\(id)")

            return await getCostDataFromCostDataDTO(costDataDTO: decoded)
            
        } catch {
            print("Error while fetching ingredients from backend: \(error)")
            return .failure(error)
        }
    }
    
    func updateDefaultCostData(costData: CostData) async -> Result<Bool, Error> {
        let costDataDTO = getCostDataDTOFromCostData(costData: costData)
        do {
            // TODO: verifier id
            let isUpdated = try await URLSession.shared.update(from: FoodlabApp.apiUrl+"cost-data/\(costData.id!)", object: costDataDTO)
            return .success(isUpdated)
        }catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
    }
    
    func updateCostData(recipeId: Int, costData: CostData) async -> Result<Bool, Error> {
        let costDataDTO = getCostDataDTOFromCostData(costData: costData)
        do {
            // TODO: verifier id
            let isUpdated = try await URLSession.shared.update(from: FoodlabApp.apiUrl+"recipe/update-cost-data/\(recipeId)", object: costDataDTO)
            return .success(isUpdated)
        }catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
        
    }

    func getCostDataDTOFromCostData(costData: CostData) -> CostDataDTO {
        return CostDataDTO(id: costData.id,
                           averageHourlyCost: .post(costData.averageHourlyCost),
                           flatrateHourlyCost: .post(costData.flatrateHourlyCost),
                           coefWithCharges: .post(costData.coefWithCharges),
                           coefWithoutCharges: .post(costData.coefWithoutCharges))
    }
    
    private func getCostDataFromCostDataDTO(costDataDTO : CostDataDTO) async -> Result<CostData,Error> {
        // manage averageHourlyCost
        let averageHourlyCost: Double
        switch costDataDTO.averageHourlyCost {
        case .post(let double):
            averageHourlyCost = double
        case .get(let string):
            guard let double = Double(string) else {
                return .failure(ConversionError.stringToDouble)
            }
            averageHourlyCost = double
        }
        
        // manage flatrateHourlyCost
        let flatrateHourlyCost: Double
        switch costDataDTO.flatrateHourlyCost {
        case .post(let double):
            flatrateHourlyCost = double
        case .get(let string):
            guard let double = Double(string) else {
                return .failure(ConversionError.stringToDouble)
            }
            flatrateHourlyCost = double
        }
        
        // manage coefWithCharges
        let coefWithCharges: Double
        switch costDataDTO.coefWithCharges {
        case .post(let double):
            coefWithCharges = double
        case .get(let string):
            guard let double = Double(string) else {
                return .failure(ConversionError.stringToDouble)
            }
            coefWithCharges = double
        }
        
        // manage unitary price
        let coefWithoutCharges: Double
        switch costDataDTO.coefWithoutCharges {
        case .post(let double):
            coefWithoutCharges = double
        case .get(let string):
            guard let double = Double(string) else {
                return .failure(ConversionError.stringToDouble)
            }
            coefWithoutCharges = double
        }
        return .success(CostData(id: costDataDTO.id,
            averageHourlyCost: averageHourlyCost,
            flatrateHourlyCost: flatrateHourlyCost,
            coefWithCharges: coefWithCharges,
            coefWithoutCharges: coefWithoutCharges))

    }
    
    
}
