//
//  ProductListView.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import SwiftUI

struct ProductListView: View {
    @ObservedObject var viewModel: ProductListViewModel
    
    init(viewModel: ProductListViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    var body: some View {
        NavigationView{
            switch viewModel.data{
            case let .success(products): ProductList(products: products)
            case let .failure(error):
               ErrorView(error: error)
            case .none:
                ProgressView()
            }
        }
        .navigationTitle("Products")
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ProductList: View{
    let products: [Product]
    var body: some View{
        List(products){ product in
            ProductView(product: product)
        }
        .navigationTitle("Products")
    }
}

struct ProductView: View{
    let product: Product
    var body: some View{
        NavigationLink(
            destination: Text("Destination"),
            label: {
                HStack{
                    Text(product.title)
                    Spacer()
                    Text(product.price)
                }
            })
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView(viewModel: ProductListViewModel())
    }
}
