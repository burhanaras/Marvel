//
//  NetworkLayer+Extension.swift
//  Modern-SwiftUI-MVVM-Tests-Marvel
//
//  Created by Burhan Aras on 5.09.2021.
//

import Foundation

extension NetworkLayer {
    struct MarvelAPI{
        static let scheme = "https"
        static let host = "gateway.marvel.com"
        
        fileprivate static let publicApiKey = "1674b346b944f391e5f9d632110f9948"
        fileprivate static let privateApiKey = "359f814b7c6c3eba6920964116c3f67dba7c3390"
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
