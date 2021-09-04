//
//  NetworkLayer.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import Foundation
import Combine
import CryptoKit

protocol INetworkLayer {
    var baseURL: NSString { get }
    func getProducts(start: Int, number: Int) -> AnyPublisher<CharactersResponse, RequestError>
    func getProductDetail(productId: String) -> AnyPublisher<MarvelDTO, RequestError>
    func getProductDetailImage(productId: String) -> AnyPublisher<ProductImagesResponse, RequestError>
}

struct MarvelServiceConstants {
    fileprivate static let publicApiKey = "1674b346b944f391e5f9d632110f9948"
    fileprivate static let privateApiKey = "359f814b7c6c3eba6920964116c3f67dba7c3390"
}


class NetworkLayer: INetworkLayer{
    var baseURL: NSString { return "https://api-sandbox.mysitoo.com/v2/accounts/90316/sites/1" as NSString }
    private let decoder = JSONDecoder()
    
    func getProducts(start: Int, number: Int) -> AnyPublisher<CharactersResponse, RequestError> {
        let ts = Date().timeIntervalSince1970.description
        let hash = MD5(string: "\(ts)\(MarvelServiceConstants.privateApiKey)\(MarvelServiceConstants.publicApiKey)")
        let url = URL(string: "https://gateway.marvel.com:443/v1/public/characters?limit=\(number)&offset=\(start)&apikey=1674b346b944f391e5f9d632110f9948&hash=\(hash)&ts=\(ts)")
        let publisher: AnyPublisher<CharactersResponse, RequestError> = fetch(url: url)
        return publisher.eraseToAnyPublisher()
    }
    
    func getProductDetail(productId: String) -> AnyPublisher<MarvelDTO, RequestError> {
        let url = URL(string: baseURL.appendingPathComponent("/products/\(productId).json"))
        let publisher: AnyPublisher<MarvelDTO, RequestError> = fetch(url: url)
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
        request.httpMethod = "GET"
        print(request)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .retry(3)
            .map{
                print(String(data: $0.data, encoding: .utf8) as Any)
                return $0.data
                
            }
            .decode(type: NetworkModel.self, decoder: self.decoder)
            .receive(on: RunLoop.main)
            .mapError{_ in return .networkError}
            .eraseToAnyPublisher()
        
    }
}

// MARK: - Network Layer To Return Dummy Data
class DummyNetworkLayer: INetworkLayer {
    var baseURL: NSString { return "https://api-sandbox.mysitoo.com/v2/accounts/90316/sites/1" as NSString }
    
    func getProducts(start: Int, number: Int) -> AnyPublisher<CharactersResponse, RequestError> {
        return Result<CharactersResponse, RequestError>
            .Publisher(.success(dummyProductsResponse))
            .eraseToAnyPublisher()
    }
    func getProductDetail(productId: String) -> AnyPublisher<MarvelDTO, RequestError> {
        return Result<MarvelDTO, RequestError>
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
    
    func getProducts(start: Int, number: Int) -> AnyPublisher<CharactersResponse, RequestError> {
        return Result<CharactersResponse, RequestError>
            .Publisher(.failure(.networkError))
            .eraseToAnyPublisher()
    }
    
    func getProductDetail(productId: String) -> AnyPublisher<MarvelDTO, RequestError> {
        return Result<MarvelDTO, RequestError>
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
    
    func getProducts(start: Int, number: Int) -> AnyPublisher<CharactersResponse, RequestError> {
        return Result<CharactersResponse, RequestError>
            .Publisher(.failure(.malformedUrlError))
            .eraseToAnyPublisher()
    }
    
    func getProductDetail(productId: String) -> AnyPublisher<MarvelDTO, RequestError> {
        return Result<MarvelDTO, RequestError>
            .Publisher(.failure(.malformedUrlError))
            .eraseToAnyPublisher()
    }
    
    func getProductDetailImage(productId: String) -> AnyPublisher<ProductImagesResponse, RequestError> {
        return Result<ProductImagesResponse, RequestError>
            .Publisher(.failure(.networkError))
            .eraseToAnyPublisher()
    }
}


var dummyProduct = Marvel(id: UUID().uuidString, title: "Slm", image: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg")!, description: "The best")
var dummyProductsResponse = CharactersResponse(code: 200, data: CharactersDataResponse(offset: 0, limit: 30, total: 151, results: DummyData.productDTOs(count: 30)))

func MD5(string: String) -> String {
    let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}
