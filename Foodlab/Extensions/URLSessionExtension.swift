//
//  URLSessionExtension.swift
//  Foodlab
//
//  Created by m1 on 19/02/2022.
//

import Foundation

enum NetworkError: Error {
    case decodedError(String)
    case URLError(String)
}

extension URLSession {
    // TODO: renommer la fonction par get par exemple
    func getJSON<T: Decodable> (from url: String) async throws -> T {
        
        guard let url = URL(string: url) else {
            throw NetworkError.URLError("Error while creating url: it is nil")
        }
        
        let (data, _) = try await data(from: url)
        guard let decoded: T = JSONHelper.decode(data: data) else {
            throw NetworkError.decodedError("Error with decoded JSON")
        }
        return decoded
    }
    
    func postJSON<T: Codable> (from url: String, object: T) async throws -> T? {
        //TODO: gerer les erreur avec enum et pas de retour vide
        guard let url = URL(string: url) else {
            print("GoRest: bad URL")
            return nil
        }
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            // append a value to a field
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            // set (replace) a value to a field
            //request.setValue("Bearer 1ccac66927c25f08de582f3919708e7aee6219352bb3f571e29566dd429ee0f0", forHTTPHeaderField: "Authorization")
            guard let encoded : Data = JSONHelper.encode(data: object) else {
                print("GoRest: pb encodage")
                return nil
            }
            
            let sencoded = String(data: encoded, encoding: .utf8)
            print(sencoded)
            
            let (data, response) = try await URLSession.shared.upload(for: request, from: encoded)
            let sdata = String(data: data, encoding: .utf8)!
            let httpresponse = response as! HTTPURLResponse
            if httpresponse.statusCode == 201 {
                print("GoRest Result: \(sdata)")
                guard let decoded : T = JSONHelper.decode(data: data) else {
                    print("GoRest: mauvaise récupération de données")
                    return nil
                }
                return decoded
                //self.users.append(decoded.data)
            }
            else{
                print("Error \(httpresponse.statusCode): \(HTTPURLResponse.localizedString(forStatusCode: httpresponse.statusCode))")
                return nil
            }
        }
        catch{
            print("GoRest: bad request")
            return nil
        }
    }
    
}
