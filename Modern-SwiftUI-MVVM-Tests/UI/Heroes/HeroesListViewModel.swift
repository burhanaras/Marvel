//
//  ProductListViewModel.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import Foundation
import Combine

class HeroesListViewModel: ObservableObject{
    @Published private(set) var data: Result<[Hero], CommonError>? = .none
    @Published private(set) var isPagingAvailable = false
    
    private var networkLayer: INetworkLayer
    private var cancellables: Set<AnyCancellable> = []
    
    private var currentPage = 0
    private var pageLimit = 30
    private var currentData = [Hero]()
    
    init(networkLayer: INetworkLayer) {
        self.networkLayer = networkLayer
        loadInitialPage()
    }
    
    func loadInitialPage(){
        subscribe(start: 0, number: pageLimit)
    }
    
    func loadNextPage() {
        guard isPagingAvailable else { return }
        self.subscribe(start: self.currentPage * self.pageLimit, number: self.pageLimit)
    }
}

extension HeroesListViewModel {
    
    private func subscribe(start: Int, number: Int) {
        networkLayer.getProducts(start: start, number: number)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion{
                case let .failure(error) where error == .malformedUrlError:
                    self?.data = .failure(.configurationError)
                case .finished:
                    break
                default:
                    self?.data = .failure(.networkError)
                }
            }, receiveValue: { [weak self] productsResponse in
                self?.currentData += productsResponse.items.map{Hero.fromDTO(dto: $0)}
                if let currentData = self?.currentData{
                    self?.data = .success(self?.currentData ?? [])
                    self?.currentPage += 1
                    self?.isPagingAvailable = currentData.count < productsResponse.totalcount
                }
            })
            .store(in: &cancellables)
    }

}
