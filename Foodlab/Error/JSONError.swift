//
//  JSONError.swift
//  Foodlab
//
//  Created by m1 on 23/02/2022.
//

import Foundation

enum JSONError {
    case decode
    case encode
    
    public var description: String {
        switch self {
        case .decode:
            return "Error while decoding data"
        case .encode:
            return "Error while encoding object in data"
        }
    }
    
    
}
