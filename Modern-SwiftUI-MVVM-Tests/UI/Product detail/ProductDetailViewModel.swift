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
    @Published private(set) var productImage: URL = URL(string: "https://via.placeholder.com/300.png/09f/fff")!
    
    private var networkLayer: INetworkLayer
    private var cancellables: Set<AnyCancellable> = []
    
    init(networkLayer: INetworkLayer, productId: String) {
        self.networkLayer = networkLayer
        subscribeToProductDetail(productId: productId)
        subscribeToProductImage(productId: productId)
    }
    
    private func subscribeToProductDetail(productId: String) {
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
    
    private func subscribeToProductImage(productId: String){
        productImage = URL(string: "https://image.tmdb.org/t/p/original//pThyQovXQrw2m0s9x82twj48Jq4.jpg")!
    }
}
