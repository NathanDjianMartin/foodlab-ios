//
//  DoubleExtension.swift
//  Foodlab
//
//  Created by Nathan Djian Martin on 02/02/2022.
//

import Foundation

extension Double {
    
    func roundTo(decimals: Int) -> String {
        return String(format: "%.\(decimals)f", self)
    }
}
