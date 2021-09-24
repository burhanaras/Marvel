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
    @Published private(set) var isComicsLoading: Bool = false
    
    private var networkLayer: INetworkLayer
    private var cancellables: Set<AnyCancellable> = []
    private var marvel: Marvel
    
    init(networkLayer: INetworkLayer, marvel: Marvel) {
        self.networkLayer = networkLayer
        self.marvel = marvel
        self.data = .success(marvel)
    }
    
    func loadProductDetail(){
        subscribeToProductDetail(characterId: marvel.id)
    }
    
    private func subscribeToProductDetail(characterId: String) {
        self.isComicsLoading = true
        networkLayer.getComicsOf(characterId: characterId)
            .sink(receiveCompletion: {[weak self] completion in
                switch completion{
                case let .failure(error) where error == .malformedUrlError:
                    self?.comics = [Comics]()
                    self?.isComicsLoading = false
                case .finished:
                    self?.isComicsLoading = false
                    break
                default:
                    self?.comics = [Comics]()
                }
            }, receiveValue: { [weak self] comicsResponse in
                self?.comics = comicsResponse.data.results.map { Comics.fromDTO(dto: $0)}
            })
            .store(in: &cancellables)
    }
    
}

