//
//  Product.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import Foundation

struct Product: Identifiable{
    let id: String
    let title: String
    let price: String
}

extension Product{
    static func fromDTO(dto: ProductDTO) -> Product{
        return Product(id: "\(dto.productid)", title: dto.title, price: dto.moneyprice)
    }
}


struct ProductsResponse: Encodable {
    let totalcount: Int
    let items: [ProductDTO]
}


struct ProductDTO: Encodable{
    let productid: Int
    let title: String
    let moneyprice: String
}

