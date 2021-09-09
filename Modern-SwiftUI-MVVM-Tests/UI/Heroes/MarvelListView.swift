//
//  ProductListView.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import SwiftUI
import Kingfisher

struct MarvelListView: View {
    @ObservedObject var viewModel: MarvelListViewModel
    
    init(viewModel: MarvelListViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    var body: some View {
        NavigationView{
            switch viewModel.data{
            case let .success(heroes): MarvelList(viewModel: viewModel, heroes: heroes)
            case let .failure(error):
               ErrorView(error: error)
            case .none:
               LoadingView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MarvelList: View{
    @ObservedObject var viewModel: MarvelListViewModel
    let heroes: [Marvel]
    
    let columns = [
        GridItem(.adaptive(minimum: UIDevice.current.model == "iPad" ? 240 : 120))
    ]
    
    var body: some View{
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(heroes) { hero in
                    MarvelRowView(hero: hero)
                        .listRowInsets(EdgeInsets())
                }
                
                if viewModel.isPagingAvailable{
                    ProgressView()
                        .onAppear{
                            viewModel.loadNextPage()
                        }
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Marvel Heroes")

    }
}

struct MarvelRowView: View{
    let hero: Marvel
    var body: some View{
        NavigationLink(
            destination: Coordinator.shared.navigateToDetail(hero: hero),
            label: {
                ZStack(alignment: .center){
                    NetworkImage(imageURL: hero.image)
                        .aspectRatio(1.0, contentMode: .fit)
                        .clipped()
                    
                    VStack {
                        Spacer()
                        Text(hero.title)
                            .bold()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .padding()
                            .background(Rectangle().foregroundColor(Color.black).opacity(0.4).blur(radius: 2.5))
                            .foregroundColor(.white)
                    }

                }
                .cornerRadius(8)
            })
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            // Successful
            MarvelListView(viewModel: MarvelListViewModel(networkLayer: DummyNetworkLayer()))
            MarvelListView(viewModel: MarvelListViewModel(networkLayer: DummyNetworkLayer()))
                .colorScheme(.dark)
            
            // Failing: Network error
            MarvelListView(viewModel: MarvelListViewModel(networkLayer: DummyFailingNetworkLayer()))
            MarvelListView(viewModel: MarvelListViewModel(networkLayer: DummyFailingNetworkLayer()))
                .colorScheme(.dark)
            
            // Failing: Malformed URL
            MarvelListView(viewModel: MarvelListViewModel(networkLayer: DummyFailingMalformedUrlNetworkLayer()))
            MarvelListView(viewModel: MarvelListViewModel(networkLayer: DummyFailingMalformedUrlNetworkLayer()))
                .colorScheme(.dark)
        }
    }
}
