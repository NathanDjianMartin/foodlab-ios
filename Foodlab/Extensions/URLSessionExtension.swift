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
    func getJSON<T: Decodable> (_ type: T.Type, from url: String) async throws -> T {
        
        guard let url = URL(string: url) else {
            throw NetworkError.URLError("Error while creating url: it is nil")
        }
        
        let (data, _) = try await data(from: url)
        guard let decoded: T = JSONHelper.decode(T.self, data: data) else {
            throw NetworkError.decodedError("Error with decoded JSON")
        }
        return decoded
    }
}
