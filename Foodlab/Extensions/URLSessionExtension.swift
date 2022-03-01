//
//  URLSessionExtension.swift
//  Foodlab
//
//  Created by m1 on 19/02/2022.
//

import Foundation

extension URLSession {
    
    func get<T: Decodable> (from url: String) async throws -> T {
        
        guard let url = URL(string: url) else {
            throw URLError.failedInit
        }
        
        let (data, _) = try await data(from: url)
        // TODO: tester si data nul ou vide
        // TODO: traiter response pour voir les http code
        guard let decoded: T = JSONHelper.decode(data: data) else {
            throw JSONError.decode
        }
        return decoded
    }
    
    func update<T: Codable> (from url: String, object: T) async throws -> Bool {
        //TODO: gerer les erreur avec enum et pas de retour vide
        guard let url = URL(string: url) else {
            throw URLError.failedInit
        }
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            // append a value to a field
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            // set (replace) a value to a field
            //request.setValue("Bearer 1ccac66927c25f08de582f3919708e7aee6219352bb3f571e29566dd429ee0f0", forHTTPHeaderField: "Authorization")
            guard let encoded : Data = JSONHelper.encode(data: object) else {
                throw JSONError.encode
            }
        
            //let sencoded = String(data: encoded, encoding: .utf8)
            
            let (data, response) = try await upload(for: request, from: encoded)
            
            let sdata = String(data: data, encoding: .utf8)!
            // TODO: risque ?
            let httpresponse = response as! HTTPURLResponse
            if httpresponse.statusCode == 200 {
                print("GoRest Result: \(sdata)")
                /*
                 guard let decoded : T = JSONHelper.decode(data: data) else {
                    throw JSONError.decode
                }
                 */
                return true
                //self.users.append(decoded.data)
                 
            }
            else{
                print("Error \(httpresponse.statusCode): \(HTTPURLResponse.localizedString(forStatusCode: httpresponse.statusCode))")
                throw HttpError.error(httpresponse.statusCode)
            }
        }
        catch{
            throw UndefinedError.error("Error in POST resquest: \(error)")
        }
    }
    
    // TODO: factoriser fonction
    func create<T: Codable> (from url: String, object: T) async throws -> T {
        //TODO: factoriser la fonction avec la fonction créate pour éviter la duplication de code
        guard let url = URL(string: url) else {
            throw URLError.failedInit
        }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            // append a value to a field
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            // set (replace) a value to a field
            //request.setValue("Bearer 1ccac66927c25f08de582f3919708e7aee6219352bb3f571e29566dd429ee0f0", forHTTPHeaderField: "Authorization")
            guard let encoded : Data = JSONHelper.encode(data: object) else {
                throw JSONError.encode
            }
        
            //let sencoded = String(data: encoded, encoding: .utf8)
            
            let (data, response) = try await URLSession.shared.upload(for: request, from: encoded)
            let sdata = String(data: data, encoding: .utf8)!
            // TODO: gérer les erreur dans une fonction à part pour la réutiliser
            let httpresponse = response as! HTTPURLResponse
            if httpresponse.statusCode == 201 {
                print("GoRest Result: \(sdata)")
                guard let decoded : T = JSONHelper.decode(data: data) else {
                    throw JSONError.decode
                }
                return decoded
                //self.users.append(decoded.data)
            }
            else{
                print("Error \(httpresponse.statusCode): \(HTTPURLResponse.localizedString(forStatusCode: httpresponse.statusCode))")
                throw HttpError.error(httpresponse.statusCode)
            }
        }
        catch{
            throw UndefinedError.error("Error in POST resquest")
        }
    }
    
    func delete(from url: String) async throws -> Bool {
        guard let url = URL(string: url) else {
            throw URLError.failedInit
        }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    
            let (_, response) = try await URLSession.shared.upload(for: request, from: Data())
            let httpresponse = response as! HTTPURLResponse
            if httpresponse.statusCode == 200 {
                return true
            } else {
                print("Error \(httpresponse.statusCode): \(HTTPURLResponse.localizedString(forStatusCode: httpresponse.statusCode))")
                throw HttpError.error(httpresponse.statusCode)
            }
        } catch {
            throw UndefinedError.error("Error in DELETE request: \(error)")
        }
    }
    
}
