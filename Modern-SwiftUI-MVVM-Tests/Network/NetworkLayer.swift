//
//  NetworkLayer.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import Foundation
import Combine

protocol INetworkLayer {
    var baseURL: NSString { get }
    func getProducts(start: Int, number: Int) -> AnyPublisher<ProductsResponse, RequestError>
    func getProductDetail(productId: String) -> AnyPublisher<ProductDTO, RequestError>
    func getProductDetailImage(productId: String) -> AnyPublisher<ProductImagesResponse, RequestError>
}

class NetworkLayer: INetworkLayer{
    var baseURL: NSString { return "https://api-sandbox.mysitoo.com/v2/accounts/90316/sites/1" as NSString }
    private let decoder = JSONDecoder()
    
    func getProducts(start: Int, number: Int) -> AnyPublisher<ProductsResponse, RequestError> {
        let url = URL(string: baseURL.appendingPathComponent("/products.json?start=\(start)&num=\(number)&fields=productid,title,moneyprice") as String)
        let publisher: AnyPublisher<ProductsResponse, RequestError> = fetch(url: url)
        return publisher.eraseToAnyPublisher()
    }
    
    func getProductDetail(productId: String) -> AnyPublisher<ProductDTO, RequestError> {
        let url = URL(string: baseURL.appendingPathComponent("/products/\(productId).json"))
        let publisher: AnyPublisher<ProductDTO, RequestError> = fetch(url: url)
        return publisher.eraseToAnyPublisher()
    }
    
    func getProductDetailImage(productId: String) -> AnyPublisher<ProductImagesResponse, RequestError> {
        let url = URL(string: baseURL.appendingPathComponent("/products/\(productId)/images.json?num=1"))
        let publisher: AnyPublisher<ProductImagesResponse, RequestError> = fetch(url: url)
        return publisher.eraseToAnyPublisher()
    }
    
    private func fetch<NetworkModel: Codable>(url: URL?) -> AnyPublisher<NetworkModel, RequestError>{
        guard let url = url else{
            return Result<NetworkModel, RequestError>
                .Publisher(.failure(.malformedUrlError))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        request.addValue("Basic OTAzMTYtMTI1OnBmWDBZN0EyVFlBbFo1NzFJS0VPN0FLb1h6YTZZbHZzUDhrS3ZBdTM=", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .retry(3)
            .map{$0.data}
            .decode(type: NetworkModel.self, decoder: self.decoder)
            .receive(on: RunLoop.main)
            .mapError{_ in return .networkError}
            .eraseToAnyPublisher()
        
    }
}

// MARK: - Network Layer To Return Dummy Data
class DummyNetworkLayer: INetworkLayer {
    var baseURL: NSString { return "https://api-sandbox.mysitoo.com/v2/accounts/90316/sites/1" as NSString }
    
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
    
    func getProductDetailImage(productId: String) -> AnyPublisher<ProductImagesResponse, RequestError> {
        return Result<ProductImagesResponse, RequestError>
            .Publisher(.failure(.networkError))
            .eraseToAnyPublisher()
    }
}

// MARK: - Network Layer To Fail
class DummyFailingNetworkLayer: INetworkLayer{
    var baseURL: NSString { return "https://api-sandbox.mysitoo.com/v2/accounts/90316/sites/1" as NSString }
    
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
    
    func getProductDetailImage(productId: String) -> AnyPublisher<ProductImagesResponse, RequestError> {
        return Result<ProductImagesResponse, RequestError>
            .Publisher(.failure(.networkError))
            .eraseToAnyPublisher()
    }
}

class DummyFailingMalformedUrlNetworkLayer: INetworkLayer{
    var baseURL: NSString { return "https://api-sandbox.mysitoo.com/v2/accounts/90316/sites/1" as NSString }
    
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
    
    func getProductDetailImage(productId: String) -> AnyPublisher<ProductImagesResponse, RequestError> {
        return Result<ProductImagesResponse, RequestError>
            .Publisher(.failure(.networkError))
            .eraseToAnyPublisher()
    }
}


var dummyProduct = Hero(id: UUID().uuidString, title: "Slm", price: "12")
var dummyProductsResponse = ProductsResponse(totalcount: 33, items: DummyData.productDTOs(count: 20))
