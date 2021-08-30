//
//  DummyData.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import Foundation

class DummyData{
    
   static func products() -> [Product]{
        var dummyProducts = [Product]()
        (0...20).forEach{ index in
            let dummyProduct = Product(id: UUID().uuidString, title: "Product \(index)", price: "15.00 USD")
            dummyProducts.append(dummyProduct)
        }
        return dummyProducts
    }
    
    static func productDTOs(count: Int) -> [ProductDTO]{
         var dummyProducts = [ProductDTO]()
         (0..<count).forEach{ index in
            let id = Int.random(in: 0...1000)
            let dummyProduct = ProductDTO(productid: id, title: "Random Product \(id)", moneyprice: "\(Int.random(in: 1...25)).00 USD")
             dummyProducts.append(dummyProduct)
         }
        return dummyProducts.sorted(by: {$0.productid < $1.productid})
     }
    
    static func productDTO(id: String) -> ProductDTO {
        return ProductDTO(productid: Int(id)!, title: "Dummy Product with ID: \(id)", moneyprice: "\(Int.random(in: 1...25)).00 USD")
    }
}
