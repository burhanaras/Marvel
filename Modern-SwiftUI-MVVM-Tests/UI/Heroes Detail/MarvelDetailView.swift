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
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                KFImage( hero.image)
                    .resizable()
                    .frame(width: 180, height: 180, alignment: .center)
                    .cornerRadius(8)
                    .padding()
                
                Text(hero.title).font(.title).padding()
                Text(hero.description.isEmpty ? "This character doesn't have any description." : hero.description).font(.body).padding()
                
                if viewModel.isComicsLoading {
                    ProgressView().padding()
                } else{
                    ComicsShelf(comics: viewModel.comics)
                }
                
                Spacer()
            }
            
        }
    }
}

struct ComicsShelf: View {
    let comics: [Comics]
    var body: some View{
        HStack {
            Text("Comics").bold()
            Spacer()
        }
        .padding()
        
        if comics.isEmpty{
            Text("This character doesn't have any comics")
                .padding()
        } else {
            ScrollView(.horizontal){
                HStack{
                    ForEach(comics){ comics in
                        ComicsView(comics: comics)
                    }
                }
            }
        }
    }
}

struct ComicsView: View{
    let comics: Comics
    var body: some View{
        VStack (alignment: .center, spacing: 4) {
            KFImage( comics.image)
                .resizable()
                .frame(width: 120, height: 120, alignment: .center)
                .cornerRadius(8)
            Text(comics.title)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(width: 120, height: 180, alignment: .center)
        .padding(4)
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            // Successful
            MarvelDetailView(viewModel: MarvelDetailViewModel(networkLayer: DummyNetworkLayer(), marvel: DummyData.marvel()))
            MarvelDetailView(viewModel: MarvelDetailViewModel(networkLayer: DummyNetworkLayer(), marvel: DummyData.marvel()))
                .colorScheme(.dark)
            
            // Failing
            MarvelDetailView(viewModel: MarvelDetailViewModel(networkLayer: DummyFailingNetworkLayer(), marvel: DummyData.marvel()))
            MarvelDetailView(viewModel: MarvelDetailViewModel(networkLayer: DummyFailingNetworkLayer(), marvel: DummyData.marvel()))
                .colorScheme(.dark)
        }
    }
}
