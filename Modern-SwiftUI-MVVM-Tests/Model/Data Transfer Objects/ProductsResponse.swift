//
//  ProductsResponse.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 30.08.2021.
//

import Foundation

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

