//
//  ProductsResponse.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 30.08.2021.
//

import Foundation

struct CharactersResponse: Codable {
    let code: Int
    public let data: CharactersDataResponse
}

public struct CharactersDataResponse: Codable {
    let offset: Int
    let limit: Int
    let total: Int  //The total number of resources available given the current filter set.
    let results: [MarvelDTO]

}

struct MarvelDTO: Codable{
    let id: Int
    let name: String
    let description: String
    var thumbnail: ThumbnailDTO
    
    enum CodingKeys: String, CodingKey {
           case id
           case name
           case description
           case thumbnail
       }
}

struct ThumbnailDTO: Codable, Hashable {
    public let path: String
    public let ext: String
    
    var completeURL: URL? {
        return URL(string: path.replacingOccurrences(of: "http", with: "https") + "." + self.ext)
    }
    
    enum CodingKeys: String, CodingKey {
        case path
        case ext = "extension"
    }
}
