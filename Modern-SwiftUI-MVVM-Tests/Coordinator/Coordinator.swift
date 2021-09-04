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
    
    func navigateToProductDetail(productId: String) -> HeroesDetailView{
        let viewModel = HeroesDetailViewModel(networkLayer: NetworkLayer(), productId: productId)
        return HeroesDetailView(viewModel: viewModel)
    }
}
