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
    func getCharacters(start: Int, number: Int) -> AnyPublisher<CharactersResponse, RequestError>
    func getComicsOf(characterId: String) -> AnyPublisher<ComicsResponse, RequestError>
}

class NetworkLayer: INetworkLayer{
    var baseURL: NSString { return "https://gateway.marvel.com:443/v1/public" as NSString }
    private let decoder = JSONDecoder()
    
    func getCharacters(start: Int, number: Int) -> AnyPublisher<CharactersResponse, RequestError> {
        guard let myurl = getComponentsForCharacters(start: start, number: number).url else {
            return Fail<CharactersResponse, RequestError>(error: .malformedUrlError)
                .eraseToAnyPublisher()
        }
        
        let publisher: AnyPublisher<CharactersResponse, RequestError> = fetch(url: myurl)
        return publisher.eraseToAnyPublisher()
    }
    
    func getComicsOf(characterId: String) -> AnyPublisher<ComicsResponse, RequestError> {
        guard let myurl = getComponentsForComics(characterId: characterId).url else {
            return Fail<ComicsResponse, RequestError>(error: .malformedUrlError)
                .eraseToAnyPublisher()
        }
        
        let publisher: AnyPublisher<ComicsResponse, RequestError> = fetch(url: myurl)
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
    var baseURL: NSString { return "https://gateway.marvel.com:443/v1/public" as NSString }
    
    func getCharacters(start: Int, number: Int) -> AnyPublisher<CharactersResponse, RequestError> {
        return Result<CharactersResponse, RequestError>
            .Publisher(.success(dummyCharactersResponse))
            .eraseToAnyPublisher()
    }
    func getComicsOf(characterId: String) -> AnyPublisher<ComicsResponse, RequestError> {
        return Result<ComicsResponse, RequestError>
            .Publisher(.success(dummyComicsResponse))
            .eraseToAnyPublisher()
    }
}

// MARK: - Network Layer To Fail
class DummyFailingNetworkLayer: INetworkLayer{
    var baseURL: NSString { return "https://gateway.marvel.com:443/v1/public" as NSString }
    
    func getCharacters(start: Int, number: Int) -> AnyPublisher<CharactersResponse, RequestError> {
        return Result<CharactersResponse, RequestError>
            .Publisher(.failure(.networkError))
            .eraseToAnyPublisher()
    }
    
    func getComicsOf(characterId: String) -> AnyPublisher<ComicsResponse, RequestError> {
        return Result<ComicsResponse, RequestError>
            .Publisher(.failure(.networkError))
            .eraseToAnyPublisher()
    }
}

class DummyFailingMalformedUrlNetworkLayer: INetworkLayer{
    var baseURL: NSString { return "https://gateway.marvel.com:443/v1/public" as NSString }
    
    func getCharacters(start: Int, number: Int) -> AnyPublisher<CharactersResponse, RequestError> {
        return Result<CharactersResponse, RequestError>
            .Publisher(.failure(.malformedUrlError))
            .eraseToAnyPublisher()
    }
    
    func getComicsOf(characterId: String) -> AnyPublisher<ComicsResponse, RequestError> {
        return Result<ComicsResponse, RequestError>
            .Publisher(.failure(.malformedUrlError))
            .eraseToAnyPublisher()
    }
}


func MD5(string: String) -> String {
    let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
    
    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}
