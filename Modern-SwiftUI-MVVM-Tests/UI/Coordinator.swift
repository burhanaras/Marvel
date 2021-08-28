//
//  Coordinator.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import Foundation
import SwiftUI

final class Coordinator{
    
    public static let shared = Coordinator()
    
    func navigateToProductDetail(productId: String) -> ProductDetailView{
        let viewModel = ProductDetailViewModel(productId: productId)
        return ProductDetailView(viewModel: viewModel)
    }
}
