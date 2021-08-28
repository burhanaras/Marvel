//
//  ProductDetailViewModel.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import Foundation

class ProductDetailViewModel: ObservableObject{
    @Published private(set) var data: Result<Product, CommonError>? = .none
    
    private var networkLayer: INetworkLayer = DummyNetworkLayer()
    
    init(productId: String) {
        subscribe(productId: productId)
    }
    
    private func subscribe(productId: String) {
        data = .success(Product(id: productId, title: "Product with id: \(productId)", price: "15.00 $"))
    }
}
