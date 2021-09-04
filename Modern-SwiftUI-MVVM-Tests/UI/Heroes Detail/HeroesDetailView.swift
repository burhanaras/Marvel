//
//  ProductDetailView.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import SwiftUI

struct HeroesDetailView: View {
    @ObservedObject var viewModel: HeroesDetailViewModel
    
    var body: some View {
        VStack {
            switch viewModel.data{
            case let .success(product): heroesDetail(product)
            case let .failure(error):
               ErrorView(error: error)
            case .none:
               LoadingView()
            }
        }
        .onAppear{
            viewModel.loadProductDetail()
        }
    }

    func heroesDetail(_ hero: Hero) -> some View{
        VStack {
            AsyncImage(
                url: viewModel.productImage,
                placeholder: { ProgressView() },
                image: { Image(uiImage: $0).resizable() }
            )
            .frame(width: 40, height: 40, alignment: .center)
            .padding()
            
            Text(hero.title) .font(.title)
            Text(hero.productGroupType).font(.body)
            Text(hero.price).font(.body)
            Spacer()
        }
        .padding()
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            // Successful
            HeroesDetailView(viewModel: HeroesDetailViewModel(networkLayer: DummyNetworkLayer(), productId: "1234"))
            HeroesDetailView(viewModel: HeroesDetailViewModel(networkLayer: DummyNetworkLayer(), productId: "1234"))
                .colorScheme(.dark)
            
            // Failing
            HeroesDetailView(viewModel: HeroesDetailViewModel(networkLayer: DummyFailingNetworkLayer(), productId: "1234"))
            HeroesDetailView(viewModel: HeroesDetailViewModel(networkLayer: DummyFailingNetworkLayer(), productId: "1234"))
                .colorScheme(.dark)
        }
    }
}
