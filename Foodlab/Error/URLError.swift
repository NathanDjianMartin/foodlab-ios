//
//  URLError.swift
//  Foodlab
//
//  Created by m1 on 23/02/2022.
//

import Foundation

enum URLError : Error {
    case failedInit
    
    public var description: String {
        switch self {
        case .failedInit:
            return "Error while creating url from string"
        }
    }
}
