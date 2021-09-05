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

struct ComicsResponse: Codable {
    let code: Int
    let data: ComicsData
}

struct ComicsData: Codable{
    let offset: Int
    let limit: Int
    let total: Int  //The total number of resources available given the current filter set.
    let results: [ComicDTO]
}

struct ComicDTO: Codable{
    let id: Int
    let title: String
    let thumbnail: ThumbnailDTO
}
