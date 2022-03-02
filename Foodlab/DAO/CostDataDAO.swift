import Foundation

struct CostDataDAO {
    //TODO: mettre un singleton? Bonne pratique?

    static var stringUrl = "http://localhost:3000/"

    static func getCostData(id: Int) async -> Result<CostData, Error> {
        do {
            // recupere tout les ingredients de la base de donnee et les transforment en IngredientDTO
            let decoded : CostDataDTO = try await URLSession.shared.get(from: stringUrl + "cost-data/\(id)")

            return .success(await getCostDataFromCostDataDTO(costDataDTO: decoded))
            
        } catch {
            print("Error while fetching ingredients from backend: \(error)")
            return .failure(error)
        }
    }
    
    static func updateDefaultCostData(costData: CostData) async -> Result<Bool, Error> {
        let costDataDTO = getCostDataDTOFromCostData(costData: costData)
        do {
            // TODO: verifier id
            let isUpdated = try await URLSession.shared.update(from: stringUrl+"cost-data/\(costData.id!)", object: costDataDTO)
            return .success(isUpdated)
        }catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
        
    }

    static func getCostDataDTOFromCostData(costData: CostData) -> CostDataDTO {
        return CostDataDTO(id: costData.id,
            averageHourlyCost: costData.averageHourlyCost,
            flatrateHourlyCost: costData.flatrateHourlyCost,
            coefWithCharges: costData.coefWithCharges,
            coefWithoutCharges: costData.coefWithoutCharges)
    }
    
    static func getCostDataFromCostDataDTO(costDataDTO : CostDataDTO) async -> CostData {
        return CostData(id: costDataDTO.id,
            averageHourlyCost: costDataDTO.averageHourlyCost,
            flatrateHourlyCost: costDataDTO.flatrateHourlyCost,
            coefWithCharges: costDataDTO.coefWithCharges,
            coefWithoutCharges: costDataDTO.coefWithoutCharges)

    }
    
    
}
