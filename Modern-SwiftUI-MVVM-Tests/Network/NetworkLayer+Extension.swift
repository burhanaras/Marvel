//
//  NetworkLayer+Extension.swift
//  Modern-SwiftUI-MVVM-Tests-Marvel
//
//  Created by Burhan Aras on 5.09.2021.
//

import Foundation
import CryptoKit

extension NetworkLayer {
    struct MarvelAPI{
        
        fileprivate static var publicApiKey: String {
          get {
            // 1
            guard let filePath = Bundle.main.path(forResource: "MarvelAPI-Keys", ofType: "plist") else {
              fatalError("Couldn't find file 'MarvelAPI-Keys.plist'.")
            }
            // 2
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "PUBLIC_API_KEY") as? String else {
              fatalError("Couldn't find key 'PUBLIC_API_KEY' in 'MarvelAPI-Keys.plist'.")
            }
            return value
          }
        }
        
        fileprivate static var privateApiKey: String {
          get {
            // 1
            guard let filePath = Bundle.main.path(forResource: "MarvelAPI-Keys", ofType: "plist") else {
              fatalError("Couldn't find file 'MarvelAPI-Keys.plist'.")
            }
            // 2
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "PRIVATE_API_KEY") as? String else {
              fatalError("Couldn't find key 'PRIVATE_API_KEY' in 'MarvelAPI-Keys.plist'.")
            }
            return value
          }
        }
        
        static let scheme = "https"
        static let host = "gateway.marvel.com"
        static let ts = Date().timeIntervalSince1970.description
        
        static func hash() -> String{
            return MD5(string: "\(ts)\(privateApiKey)\(publicApiKey)")
        }
    }

    
    func getComponentsForCharacters(start: Int, number: Int) -> URLComponents {
        var components = URLComponents()
        components.scheme = MarvelAPI.scheme
        components.host = MarvelAPI.host
        components.path = "/v1/public/characters"

        components.queryItems = [
            .init(name: "limit", value: String(number)),
            .init(name: "offset", value: String(start)),
            .init(name: "apikey", value: MarvelAPI.publicApiKey),
            .init(name: "ts", value: String(MarvelAPI.ts)),
            .init(name: "hash", value: MarvelAPI.hash())
        ]
        return components
    }
    
    func getComponentsForComics(characterId: String) -> URLComponents{
        var components = URLComponents()
        components.scheme = MarvelAPI.scheme
        components.host = MarvelAPI.host
        components.path = "/v1/public/characters/\(characterId)/comics"

        components.queryItems = [
            .init(name: "dateRange", value: "2005-01-01,2023-01-02"),
            .init(name: "orderBy", value: "onsaleDate"),
            .init(name: "limit", value: "10"),
            .init(name: "apikey", value: MarvelAPI.publicApiKey),
            .init(name: "ts", value: String(MarvelAPI.ts)),
            .init(name: "hash", value: MarvelAPI.hash())
        ]
        return components
    }
    
}

func MD5(string: String) -> String {
    let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
    
    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}
