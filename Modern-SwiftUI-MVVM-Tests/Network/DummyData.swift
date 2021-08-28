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
}
