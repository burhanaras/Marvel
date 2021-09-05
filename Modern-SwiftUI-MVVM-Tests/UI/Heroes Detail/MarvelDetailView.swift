//
//  ProductDetailView.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import SwiftUI
import Kingfisher

struct MarvelDetailView: View {
    @ObservedObject var viewModel: MarvelDetailViewModel
    
    var body: some View {
        VStack {
            switch viewModel.data{
            case let .success(marvel): heroesDetail(marvel)
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

    func heroesDetail(_ hero: Marvel) -> some View{
        VStack {
            KFImage( hero.image)
                .resizable()
                .frame(width: 180, height: 180, alignment: .center)
                .cornerRadius(8)
                .padding()
            
            Text(hero.title) .font(.title)
            Text(hero.description).font(.body)
            
            ScrollView(.horizontal){
                HStack{
                    ForEach(viewModel.comics){ comics in
                        Text(comics.title)
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            // Successful
            MarvelDetailView(viewModel: MarvelDetailViewModel(networkLayer: DummyNetworkLayer(), hero: DummyData.marvel()))
            MarvelDetailView(viewModel: MarvelDetailViewModel(networkLayer: DummyNetworkLayer(), hero: DummyData.marvel()))
                .colorScheme(.dark)
            
            // Failing
            MarvelDetailView(viewModel: MarvelDetailViewModel(networkLayer: DummyFailingNetworkLayer(), hero: DummyData.marvel()))
            MarvelDetailView(viewModel: MarvelDetailViewModel(networkLayer: DummyFailingNetworkLayer(), hero: DummyData.marvel()))
                .colorScheme(.dark)
        }
    }
}
