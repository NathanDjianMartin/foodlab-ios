//
//  URLError.swift
//  Foodlab
//
//  Created by m1 on 23/02/2022.
//

import Foundation

enum URLError : Error {
    case cast
    
    public var description: String {
        switch self {
        case .cast:
            return "Error while creating url from string"
        }
    }
}
