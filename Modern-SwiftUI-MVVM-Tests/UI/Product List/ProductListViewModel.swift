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
        data = .success(dummyProducts)
        isPagingAvailable = dummyProducts.count < 50
    }
    
    func loadNextPage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            guard var newData = try? self.data?.get() else { return }
            newData += dummyProducts
            self.data = .success(newData)
            self.isPagingAvailable = newData.count < 50
        })

    }
}


// Dummy data

let dummyProduct0 = Product(id: "0", title: "Peoduct 0", price: "15.00 USD")
let dummyProduct1 = Product(id: "1", title: "Peoduct 1", price: "15.00 USD")
let dummyProduct2 = Product(id: "2", title: "Peoduct 2", price: "15.00 USD")
let dummyProduct3 = Product(id: "3", title: "Peoduct 3", price: "15.00 USD")
let dummyProduct4 = Product(id: "4", title: "Peoduct 4", price: "15.00 USD")
let dummyProducts = [dummyProduct0, dummyProduct1, dummyProduct2, dummyProduct3, dummyProduct4, dummyProduct0, dummyProduct1, dummyProduct2, dummyProduct3, dummyProduct4]
