//
//  JSONHelper.swift
//  Foodlab
//
//  Created by m1 on 17/02/2022.
//

import Foundation


import Foundation

struct JSONHelper{
    
    static func encode<T:Codable>(data : T){
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let json = try? encoder.encode(data)
        
        guard let jsonData = json else {
            print("json is empty")
            return
        }
        
    }
    
    static func decode<T: Decodable>(data: Data) -> T? {
        
        let decoder = JSONDecoder() // création d'un décodeur
        if let decoded = try? decoder.decode(T.self, from:data) {
            // si on a réussit à décoder self.tracks = decoded
            return decoded
        }
        return nil
    }
}
