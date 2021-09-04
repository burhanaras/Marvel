//
//  Product.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import Foundation

struct Hero: Identifiable, Equatable{
    let id: String
    let title: String
    let image = "https://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg"
    let description: String = "Lorem ipsum etc...."
    let price: String
    var productGroupType: String = ""
}

extension Hero{
    static func fromDTO(dto: ProductDTO) -> Hero{
        var product =  Hero(id: "\(dto.productid)", title: dto.title, price: dto.moneyprice)
        product.productGroupType = "\(dto.productgrouptype ?? 0)"
        return product
    }
}
