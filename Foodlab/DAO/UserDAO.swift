//
//  UserDAO.swift
//  Foodlab
//
//  Created by m1 on 17/02/2022.
//

import Foundation

struct UserDAO {
    //TODO : mettre url en variable d'environnement
    var stringUrl = "51.75.248.77:3000/"
    
    func getAllUsers() async -> [User]? {
            do {
                
                // faire la requête vers le backend
                guard let url = URL(string: stringUrl + "user")
                else { return nil }
                let (data, _) = try await URLSession.shared.data(from: url)
                
                
                // decoder le JSON avec la fonction présente dans JSONHelper
                guard let decoded: [UserDTO] = JSONHelper.decode([UserDTO].self, data: data)
                else { return nil }
                
                // dans une boucle transformer chaque UserDTO en model User
                var users: [User] = []
                for userDTO in decoded {
                    users.append( getUserFromUserDTO(userDTO: userDTO))
                }
                
                // retourner une liste de User
                return users
                
            } catch {
                print("Error while fetching users from backend: \(error)")
                return nil
            }
        }
    
    func getUserById(id: Int) async -> User? {
            do {
                
                // faire la requête vers le backend
                guard let url = URL(string: stringUrl + "detail+id")
                else { return nil }
                let (data, _) = try await URLSession.shared.data(from: url)
                
                
                // decoder le JSON avec la fonction présente dans JSONHelper
                guard let userDTO: UserDTO = JSONHelper.decode(UserDTO.self, data: data)
                else { return nil }
                
                // retourner une liste de User
                return getUserFromUserDTO(userDTO: userDTO)
                
            } catch {
                print("Error while fetching users from backend: \(error)")
                return nil
            }
        }

    
    func getUserFromUserDTO(userDTO : UserDTO) -> User {
        let user = User(
            id: userDTO.id,
            name: userDTO.name,
            email: userDTO.email,
            password: userDTO.password,
            isAdmin: userDTO.isAdmin )
        
        return user
    }
}
