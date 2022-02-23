//
//  URLError.swift
//  Foodlab
//
//  Created by m1 on 23/02/2022.
//

import Foundation

enum URLError {
    case cast
    
    public var description: String {
        switch self {
        case .cast:
            return "Error while cast string in URL"
        }
    }
}
