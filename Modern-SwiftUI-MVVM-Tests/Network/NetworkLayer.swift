//
//  NetworkLayer.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import Foundation
import Combine

protocol INetworkLayer {
    func getProducts(start: Int, number: Int) -> AnyPublisher<ProductsResponse, RequestError>
    func getProductDetail(productId: String) -> AnyPublisher<ProductDTO, RequestError>
}

// MARK: - Network Layer To Return Dummy Data
class DummyNetworkLayer: INetworkLayer {
    
    func getProducts(start: Int, number: Int) -> AnyPublisher<ProductsResponse, RequestError> {
        return Result<ProductsResponse, RequestError>
            .Publisher(.success(dummyProductsResponse))
            .eraseToAnyPublisher()
    }
    func getProductDetail(productId: String) -> AnyPublisher<ProductDTO, RequestError> {
        return Result<ProductDTO, RequestError>
            .Publisher(.success(DummyData.productDTO(id: productId)))
            .eraseToAnyPublisher()
    }
}

// MARK: - Network Layer To Fail
class DummyFailingNetworkLayer: INetworkLayer{
    
    func getProducts(start: Int, number: Int) -> AnyPublisher<ProductsResponse, RequestError> {
        return Result<ProductsResponse, RequestError>
            .Publisher(.failure(.networkError))
            .eraseToAnyPublisher()
    }
    
    func getProductDetail(productId: String) -> AnyPublisher<ProductDTO, RequestError> {
        return Result<ProductDTO, RequestError>
            .Publisher(.failure(.networkError))
            .eraseToAnyPublisher()
    }
}

class DummyFailingMalformedUrlNetworkLayer: INetworkLayer{
    
    func getProducts(start: Int, number: Int) -> AnyPublisher<ProductsResponse, RequestError> {
        return Result<ProductsResponse, RequestError>
            .Publisher(.failure(.malformedUrlError))
            .eraseToAnyPublisher()
    }
    
    func getProductDetail(productId: String) -> AnyPublisher<ProductDTO, RequestError> {
        return Result<ProductDTO, RequestError>
            .Publisher(.failure(.malformedUrlError))
            .eraseToAnyPublisher()
    }
}


var dummyProduct = Product(id: UUID().uuidString, title: "Slm", price: "12")
var dummyProductsResponse = ProductsResponse(totalcount: 33, items: DummyData.productDTOs(count: 20))
