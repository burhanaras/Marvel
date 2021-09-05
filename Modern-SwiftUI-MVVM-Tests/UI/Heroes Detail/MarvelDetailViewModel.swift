//
//  ProductDetailViewModel.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import Foundation
import Combine

class MarvelDetailViewModel: ObservableObject{
    @Published private(set) var data: Result<Marvel, CommonError>? = .none
    @Published private(set) var comics: [Comics] = [Comics]()
    
    private var networkLayer: INetworkLayer
    private var cancellables: Set<AnyCancellable> = []
    private var hero: Marvel
    
    init(networkLayer: INetworkLayer, hero: Marvel) {
        self.networkLayer = networkLayer
        self.hero = hero

    }
    
    func loadProductDetail(){
        subscribeToProductDetail(characterId: hero.id)
//        subscribeToProductImage(productId: productID)
        
        self.data = .success(hero)
    }
    
    private func subscribeToProductDetail(characterId: String) {
        networkLayer.getComicsOf(productId: characterId)
            .sink(receiveCompletion: {[weak self] completion in
                switch completion{
                case let .failure(error) where error == .malformedUrlError:
                    self?.data = .failure(.configurationError)
                case .finished:
                    break
                default:
                    self?.data = .failure(.networkError)
                }
            }, receiveValue: { [weak self] comicsResponse in
                self?.comics = comicsResponse.data.results.map { Comics.fromDTO(dto: $0)}
            })
            .store(in: &cancellables)
    }
    
}

var defaultImageURL = "https://via.placeholder.com/300.png"
