import Foundation

extension URLSession {
    /*
    func get<T: Decodable> (from url: String) async throws -> T {
        
        guard let url = URL(string: url) else {
            throw URLError.failedInit
        }
        
        let (data, _) = try await data(from: url)
        // TODO: tester si data nul ou vide
        // TODO: traiter response pour voir les http code
        //        guard let decoded: T = JSONHelper.decode(data: data) else {
        //            throw JSONError.decode
        //        }
        //        return decoded
        let result: Result<T, Error> = JSONHelper.decodeWithError(data: data)
        switch result {
        case .success(let result):
            return result
        case .failure(let error):
            throw error
        }
    }
    */
    
    func get<T: Decodable> (from url: String) async throws -> T {
        guard let url = URL(string: url) else {
            throw URLError.failedInit
        }
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            // append a value to a field
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            // set (replace) a value to a field
            if let token = KeychainHelper.standard.getJWT() {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let (data, response) = try await data(for: request)
            
            let httpresponse = response as! HTTPURLResponse
            if httpresponse.statusCode == 200 {
                
                 guard let decoded : T = JSONHelper.decode(data: data) else {
                 throw JSONError.decode
                 }
                 
                return decoded
                
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
    
    func update<T: Codable> (from url: String, object: T) async throws -> Bool {
        
        guard let url = URL(string: url) else {
            throw URLError.failedInit
        }
        do{
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            // append a value to a field
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            // set (replace) a value to a field
            if let token = KeychainHelper.standard.getJWT() {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
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
            throw UndefinedError.error("Error in PATCH resquest: \(error)")
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
            if let token = KeychainHelper.standard.getJWT() {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
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
    
    func login(credentialsDTO: CredentialsDTO) async throws -> Bool {
        guard let url = URL(string: FoodlabApp.apiUrl + "auth/login") else {
            throw URLError.failedInit
        }
        
        do{
            var request = URLRequest(url: url)
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            guard let encoded = JSONHelper.encode(data: credentialsDTO) else {
                throw JSONError.encode
            }
            
            let (data, response) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let httpresponse = response as! HTTPURLResponse
            
            if httpresponse.statusCode == 201{
                
                guard let decoded : TokenDTO = JSONHelper.decode(data: data) else {
                    throw JSONError.decode
                }
                if(decoded.access_token != nil){
                    KeychainHelper.standard.saveJWT(token: decoded.access_token)
                }
                return true
            } else if httpresponse.statusCode == 401 {
                throw HttpError.unauthorized("Email or password invalid")
            }
            else{
                print(httpresponse.statusCode)
                throw UndefinedError.error("Error while login")
            }
        }
        catch(let error){
            throw error
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
            if let token = KeychainHelper.standard.getJWT() {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
                    
            let (_, response) = try await URLSession.shared.upload(for: request, from: Data())
            let httpresponse = response as! HTTPURLResponse
            if httpresponse.statusCode == 200 {
                return true
            } else if httpresponse.statusCode == 409 {
                throw HttpError.conflict("Conflict in delete")
            } else {
                print("Error \(httpresponse.statusCode): \(HTTPURLResponse.localizedString(forStatusCode: httpresponse.statusCode))")
                throw HttpError.error(httpresponse.statusCode)
            }
        } catch {
            throw error
        }
    }
    
}
