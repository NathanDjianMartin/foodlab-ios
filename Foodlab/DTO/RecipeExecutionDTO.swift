//
//  StepDTO.swift
//  Foodlab
//
//  Created by m1 on 16/02/2022.
//

import Foundation

struct RecipeExecutionDTO: Identifiable {
    var id: Int?
    var isStep: Bool
    var stepTitle: String
    var stepDescription: String?
    var duration: Int?
    
    init(id: Int? = nil, isStep: Bool, stepTitle: String, stepDescription: String? = nil, duration: Int? = nil) {
        self.id = id
        self.isStep = isStep
        self.stepTitle = stepTitle
        self.stepDescription = stepDescription
        self.duration = duration
    }
    
}
