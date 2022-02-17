//
//  Step.swift
//  Foodlab
//
//  Created by m1 on 17/02/2022.
//

import Foundation

protocol Step: Identifiable, AnyObject {
    
    var id: Int? { get set }
    var stepTitle: String { get set }

    
}
