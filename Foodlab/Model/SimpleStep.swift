//
//  SimpleStep.swift
//  Foodlab
//
//  Created by m1 on 17/02/2022.
//

import Foundation

class SimpleStep: Step {
    
    var id: Int?
    var stepTitle: String
    var stepDescription: String
    var duration: Int
    
    init(id: Int? = nil, stepTitle: String, stepDescription: String, duration: Int) {
        self.id = id
        self.stepTitle = stepTitle
        self.stepDescription = stepDescription
        self.duration = duration
    }
    
}
