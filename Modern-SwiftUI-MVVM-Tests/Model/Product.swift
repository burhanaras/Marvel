//
//  Product.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import Foundation

struct Product: Identifiable, Equatable{
    let id: String
    let title: String
    let price: String
    var productGroupType: String = ""
}

extension Product{
    static func fromDTO(dto: ProductDTO) -> Product{
        var product =  Product(id: "\(dto.productid)", title: dto.title, price: dto.moneyprice)
        product.productGroupType = "\(dto.productgrouptype ?? 0)"
        return product
    }
}


struct ProductsResponse: Codable {
    let totalcount: Int
    let items: [ProductDTO]
}


struct ProductDTO: Codable{
    let productid: Int
    let title: String
    let moneyprice: String
    var productgrouptype: Int?
}

