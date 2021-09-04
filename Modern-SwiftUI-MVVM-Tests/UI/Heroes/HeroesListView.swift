//
//  ProductListView.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import SwiftUI
import Kingfisher

struct HeroesListView: View {
    @ObservedObject var viewModel: HeroesListViewModel
    
    init(viewModel: HeroesListViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    var body: some View {
        NavigationView{
            switch viewModel.data{
            case let .success(heroes): HeroesList(viewModel: viewModel, heroes: heroes)
            case let .failure(error):
               ErrorView(error: error)
            case .none:
               LoadingView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HeroesList: View{
    @ObservedObject var viewModel: HeroesListViewModel
    let heroes: [Hero]
    
    var body: some View{
        List {
            ForEach(heroes){ hero in
                HeroesView(hero: hero)
            }
            
            if viewModel.isPagingAvailable{
                ProgressView()
                    .onAppear{
                        viewModel.loadNextPage()
                    }
            }
        }
        .navigationTitle("Marvel Heroes")
    }
}

struct HeroesView: View{
    let hero: Hero
    var body: some View{
        NavigationLink(
            destination: Coordinator.shared.navigateToProductDetail(productId: hero.id),
            label: {
                HStack{
                    KFImage( URL(string: hero.image)!)
                        .resizable()
                        .frame(width: 60, height: 60, alignment: .center)
                        .cornerRadius(8)
                        .padding()
                    Text(hero.title)
                }
            })
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            // Successful
            HeroesListView(viewModel: HeroesListViewModel(networkLayer: DummyNetworkLayer()))
            HeroesListView(viewModel: HeroesListViewModel(networkLayer: DummyNetworkLayer()))
                .colorScheme(.dark)
            
            // Failing: Network error
            HeroesListView(viewModel: HeroesListViewModel(networkLayer: DummyFailingNetworkLayer()))
            HeroesListView(viewModel: HeroesListViewModel(networkLayer: DummyFailingNetworkLayer()))
                .colorScheme(.dark)
            
            // Failing: Malformed URL
            HeroesListView(viewModel: HeroesListViewModel(networkLayer: DummyFailingMalformedUrlNetworkLayer()))
            HeroesListView(viewModel: HeroesListViewModel(networkLayer: DummyFailingMalformedUrlNetworkLayer()))
                .colorScheme(.dark)
        }
    }
}
