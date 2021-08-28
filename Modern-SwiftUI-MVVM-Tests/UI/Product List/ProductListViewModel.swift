//
//  ProductListViewModel.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import Foundation

class ProductListViewModel: ObservableObject{
    @Published private(set) var data: Result<[Product], CommonError>? = .none
    @Published private(set) var isPagingAvailable = false
    
    init() {
        subscribe()
    }
}

extension ProductListViewModel {
    private func subscribe() {
        data = .success(DummyData.products())
        guard let dataCount = try? self.data?.get().count else { return }
        isPagingAvailable = dataCount < 50
    }
    
    func loadNextPage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            guard var newData = try? self.data?.get() else { return }
            newData += DummyData.products()
            self.data = .success(newData)
            self.isPagingAvailable = newData.count < 50
        })

    }
}
