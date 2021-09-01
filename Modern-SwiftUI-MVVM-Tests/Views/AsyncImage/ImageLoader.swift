//
//  ImageLoader.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 30.08.2021.
//

import Combine
import UIKit

enum ImageLoaderStatus{
    case loading
    case success
    case timeout
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published private(set) var status: ImageLoaderStatus = .loading
    
    private let url: URL
    private var cache: ImageCache?
    private var cancellable: AnyCancellable?
    private(set) var isLoading = false
    
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    
    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        guard !isLoading else { return }

        if let image = cache?[url] {
            self.image = image
            return
        }
        
        // Timeout is 2 secs.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.status = .timeout
            self.cancel()
            return
        })
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: UIImage(named: "Placeholder"))
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                          receiveOutput: { [weak self] in self?.cache($0) },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .subscribe(on: Self.imageProcessingQueue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
    
    private func cache(_ image: UIImage?) {
        image.map { cache?[url] = $0 }
    }
}
