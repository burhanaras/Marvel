//
//  ProductImagesResponse.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 30.08.2021.
//

import Foundation

struct ProductImagesResponse: Codable{
    let totalcount: Int
    let items: [ProductImageDTO]
}

struct ProductImageDTO: Codable {
    let resourceid: String
}
