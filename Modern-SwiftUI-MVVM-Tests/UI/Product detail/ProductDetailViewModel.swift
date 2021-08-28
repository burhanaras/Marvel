//
//  ProductDetailViewModel.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import Foundation
import Combine

class ProductDetailViewModel: ObservableObject{
    @Published private(set) var data: Result<Product, CommonError>? = .none
    
    private var networkLayer: INetworkLayer
    private var cancellables: Set<AnyCancellable> = []
    
    init(networkLayer: INetworkLayer, productId: String) {
        self.networkLayer = networkLayer
        subscribe(productId: productId)
    }
    
    private func subscribe(productId: String) {
        networkLayer.getProductDetail(productId: productId)
            .sink(receiveCompletion: {[weak self] completion in
                switch completion{
                case let .failure(error) where error == .malformedUrlError:
                    self?.data = .failure(.configurationError)
                case .finished:
                    break
                default:
                    self?.data = .failure(.networkError)
                }
            }, receiveValue: { [weak self] productDTO in
                self?.data = .success(Product.fromDTO(dto: productDTO))
            })
            .store(in: &cancellables)
    }
}
