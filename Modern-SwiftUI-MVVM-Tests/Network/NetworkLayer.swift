//
//  NetworkLayer.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import Foundation
import Combine

protocol INetworkLayer {
    var products: AnyPublisher<ProductsResponse, RequestError> { get }
    func getProducts(start: Int, number: Int) -> AnyPublisher<ProductsResponse, RequestError>
    func getProductDetail() -> AnyPublisher<Product, RequestError>
}

class DummyNetworkLayer: INetworkLayer {
    
    var products: AnyPublisher<ProductsResponse, RequestError>{
        return Result<ProductsResponse, RequestError>
            .Publisher(.success(dummyProductsResponse))
            .eraseToAnyPublisher()
    }
    
    func getProducts(start: Int, number: Int) -> AnyPublisher<ProductsResponse, RequestError> {
        return Result<ProductsResponse, RequestError>
            .Publisher(.success(dummyProductsResponse))
            .eraseToAnyPublisher()
    }
    func getProductDetail() -> AnyPublisher<Product, RequestError> {
        return Result<Product, RequestError>
            .Publisher(.success(dummyProduct))
            .eraseToAnyPublisher()
    }
}

var dummyProduct = Product(id: UUID().uuidString, title: "Slm", price: "12")
var dummyProductsResponse = ProductsResponse(totalcount: 33, items: DummyData.productDTOs(count: 20))
