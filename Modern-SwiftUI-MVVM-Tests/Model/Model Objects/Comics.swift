//
//  Comics.swift
//  Modern-SwiftUI-MVVM-Tests-Marvel
//
//  Created by Burhan Aras on 5.09.2021.
//

import Foundation

struct Comics: Identifiable {
    let id: Int
    let title: String
    let image: URL
}

extension Comics{
    static func fromDTO(dto: ComicDTO) -> Comics {
        return Comics(id: dto.id, title: dto.title, image: dto.thumbnail.completeURL ?? URL(string: "")!)
    }
}
