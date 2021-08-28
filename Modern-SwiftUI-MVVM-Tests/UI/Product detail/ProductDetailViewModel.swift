//
//  ProductDetailViewModel.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import Foundation

class ProductDetailViewModel: ObservableObject{
    @Published private(set) var data: Result<Product, CommonError>? = .none
    
    init(productId: String) {
        subscribe(productId: productId)
    }
    
    private func subscribe(productId: String) {
        
    }
}
