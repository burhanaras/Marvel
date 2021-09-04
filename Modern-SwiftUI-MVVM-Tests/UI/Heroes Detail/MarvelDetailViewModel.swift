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
    @Published private(set) var productImage: URL = URL(string: defaultImageURL)!
    
    private var networkLayer: INetworkLayer
    private var cancellables: Set<AnyCancellable> = []
    private var hero: Marvel
    
    init(networkLayer: INetworkLayer, hero: Marvel) {
        self.networkLayer = networkLayer
        self.hero = hero

    }
    
    func loadProductDetail(){
//        subscribeToProductDetail(productId: productID)
//        subscribeToProductImage(productId: productID)
        
        self.data = .success(hero)
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
                self?.data = .success(Marvel.fromDTO(dto: productDTO))
            })
            .store(in: &cancellables)
    }
    
    private func subscribeToProductImage(productId: String){        
        networkLayer.getProductDetailImage(productId: productId)
            .sink(receiveCompletion: {[weak self] completion in
                switch completion{
                case let .failure(error) where error == .malformedUrlError:
                    self?.productImage = URL(string: defaultImageURL)!
                case .finished:
                    break
                default:
                    self?.productImage = URL(string: defaultImageURL)!
                }
            }, receiveValue: { [weak self] productImagesResponse in
                guard productImagesResponse.items.count > 0 else {
                    self?.productImage = URL(string: defaultImageURL)!
                    return
                }
                let imageURL = (self?.networkLayer.baseURL)!  as String + "/" + productImagesResponse.items[0].resourceid
                if let image =  URL(string: imageURL) {
                    self?.productImage = image
                    print("Image url is \(imageURL)")
                } else {
                    self?.productImage = URL(string: defaultImageURL)!
                }
            })
            .store(in: &cancellables)
    }
}

var defaultImageURL = "https://via.placeholder.com/300.png"
