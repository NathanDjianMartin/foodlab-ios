//
//  JSONHelper.swift
//  Foodlab
//
//  Created by m1 on 17/02/2022.
//

import Foundation


import Foundation

struct JSONHelper{
    
    static func encode<T:Codable> (data : T) -> Data?{
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let json = try? encoder.encode(data)
        
        guard json != nil else {
            print("json is empty")
            return nil
        }
        return json
        
    }
    
    static func decode<T: Decodable>(data: Data) -> T? {
        
        let decoder = JSONDecoder() // création d'un décodeur
        if let decoded = try? decoder.decode(T.self, from: data) {
            return decoded
        }
        return nil
    }
}
