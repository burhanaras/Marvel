//
//  EnvironmentValues+ImageCache.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 30.08.2021.
//

import SwiftUI

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
