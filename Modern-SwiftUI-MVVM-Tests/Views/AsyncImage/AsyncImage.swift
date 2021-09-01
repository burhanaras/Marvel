//
//  AsyncImage.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 30.08.2021.
//

import Foundation
import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    private let image: (UIImage) -> Image
    
    init(
        url: URL,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)
    ) {
        self.placeholder = placeholder()
        self.image = image
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
    }
    
    var body: some View {
        content
            .onAppear(perform: loader.load)
    }
    
    private var content: some View {
        Group {
            switch loader.status{
            case .loading: placeholder
            case .success: image(loader.image!)
            case .timeout: image(UIImage(named: "Placeholder")!)
            }
        }
    }
}
