//
//  ErrorConversion.swift
//  Foodlab
//
//  Created by m1 on 23/02/2022.
//

import Foundation

enum ConversionError : Error {
    case stringToDouble
    
    public var description: String {
        switch self {
        case .stringToDouble:
            return "Error while cast string to double"
        }
    }
}
