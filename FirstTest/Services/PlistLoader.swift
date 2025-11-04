//
//  PlistLoader.swift
//  FirstTest
//
//  Created by Адлет Жумагалиев on 30.10.2025.
//

import Foundation

enum PlistLoaderError: Error {
    case fileNotFound
    case decodingFailed
}

protocol PlistLoaderProtocol: AnyObject {
    func loadData<T: Decodable>(
        named fileName: String,
        completion: @escaping (Result<T, PlistLoaderError>) -> Void
    )
}

final class PlistLoader: PlistLoaderProtocol {
    func loadData<T>(named fileName: String, completion: @escaping (Result<T, PlistLoaderError>) -> Void) where T : Decodable {
        DispatchQueue.global(qos: .background).async {
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "plist") else {
                completion(.failure(.fileNotFound))
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = PropertyListDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }
    }
    
    
}
