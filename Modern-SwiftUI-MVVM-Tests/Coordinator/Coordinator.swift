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
    
    func navigateToDetail(hero: Marvel) -> MarvelDetailView{
        let viewModel = MarvelDetailViewModel(networkLayer: NetworkLayer(), hero: hero)
        return MarvelDetailView(viewModel: viewModel)
    }
}
