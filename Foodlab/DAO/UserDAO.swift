//
//  UserDAO.swift
//  Foodlab
//
//  Created by m1 on 17/02/2022.
//

import Foundation

struct UserDAO {
    // MARK: singleton conformance
    
    static var shared: UserDAO = {
        return UserDAO()
    }()
    
    private init() {}
    
    func getAllUsers() async -> Result<[User], Error> {
        do {
            // recupere tout les ingredients de la base de donnee et les transforment en IngredientDTO
            let decoded : [UserDTO] = try await URLSession.shared.get(from: FoodlabApp.apiUrl + "user")
            
            // dans une boucle transformer chaque IngredientDTO en model Ingredient
            var users: [User] = []
            for userDTO in decoded {
                users.append(getUserFromUserDTO(userDTO: userDTO))
            }
            
            // retourner une liste de User
            return .success(users)
            
        } catch {
            print("Error while fetching users from backend: \(error)")
            return .failure(error)
        }
        
    }
    
    func getUserById(id: Int) async -> Result<User, Error> {
        do {
            
            // decoder le JSON avec la fonction présente dans JSONHelper
            let userDTO : UserDTO = try await URLSession.shared.get(from: FoodlabApp.apiUrl + "user/\(id)")
            
            // retourner un Result avec ingredient ou error
            return .success(getUserFromUserDTO(userDTO: userDTO))
            
        } catch {
            print("Error while fetching ingredient from backend: \(error)")
            return .failure(error)
        }
    }
    
    func getProfile() async -> Result<User, Error> {
        do {
            
            // decoder le JSON avec la fonction présente dans JSONHelper
            let userDTO : UserDTO = try await URLSession.shared.get(from: FoodlabApp.apiUrl + "user/profile")
            
            // retourner un Result avec ingredient ou error
            return .success(getUserFromUserDTO(userDTO: userDTO))
            
        } catch {
            print("Error while fetching ingredient from backend: \(error)")
            return .failure(error)
        }
    }
    
    
    func createUser(user: User) async -> Result<User, Error> {
        let userDTO = getUserDTOFromUser(user: user)
        do {
            //TODO: verifier id
            let decoded : UserDTO = try await URLSession.shared.create(from: FoodlabApp.apiUrl + "user/create", object: userDTO)
            return .success(getUserFromUserDTO(userDTO: decoded))
        } catch {
            // on propage l'erreur transmise par la fonction post
            return .failure(error)
        }
    }
    
    func deleteUserById(_ id: Int) async -> Result<Bool, Error> {
        do {
            let deleted: Bool = try await URLSession.shared.delete(from: FoodlabApp.apiUrl + "user/\(id)")
            return .success(deleted)
        } catch {
            return .failure(error)
        }
    }
    
     func login(email: String, password : String) async -> Result<Bool, Error> {
        
        let credentialsDTO = CredentialsDTO(email: email, password: password)
        
        do {
            let decoded: Bool = try await URLSession.shared.login(credentialsDTO: credentialsDTO)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
        
    }
    
    private func getUserDTOFromUser(user : User) -> UserDTO {
        let userDTO = UserDTO(
            id: user.id,
            name: user.name,
            email: user.email,
            password: user.password,
            isAdmin: user.isAdmin )
        
        return userDTO
    }
    
    private func getUserFromUserDTO(userDTO : UserDTO) -> User {
        let user = User(
            id: userDTO.id,
            name: userDTO.name,
            email: userDTO.email,
            password: userDTO.password,
            isAdmin: userDTO.isAdmin )
        
        return user
    }
}

