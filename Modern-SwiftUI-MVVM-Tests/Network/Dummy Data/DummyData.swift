//
//  DummyData.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import Foundation

class DummyData{
    
   static func products() -> [Marvel]{
        var dummyProducts = [Marvel]()
        (0...20).forEach{ index in
            let dummyProduct = Marvel(id: UUID().uuidString, title: "Product \(index)", image: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg")!, description: "The best")
            dummyProducts.append(dummyProduct)
        }
        return dummyProducts
    }
    
    static func productDTOs(count: Int) -> [MarvelDTO]{
         var dummyProducts = [MarvelDTO]()
         (0..<count).forEach{ index in
            let id = Int.random(in: 0...1000)
            let dummyProduct = MarvelDTO(id: id, name: "Random Product \(id)", description: "\(Int.random(in: 1...25)).00 USD", thumbnail: ThumbnailDTO(path: "https://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784", ext: "jpg"))
             dummyProducts.append(dummyProduct)
         }
        return dummyProducts.sorted(by: {$0.id < $1.id})
     }
    
    static func productDTO(id: String) -> MarvelDTO {
        return MarvelDTO(id: Int(id)!, name: "Dummy Product with ID: \(id)", description: "\(Int.random(in: 1...25)).00 USD", thumbnail: ThumbnailDTO(path: "https://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784", ext: "jpg"))
    }
    static func hero() -> Marvel {
        return Marvel(id: "123", title: "Iron Man", image: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg")!, description: "I'm Iron Man")
    }
}
