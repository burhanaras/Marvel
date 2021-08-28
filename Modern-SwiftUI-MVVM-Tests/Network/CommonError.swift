//
//  CommonError.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import Foundation

enum CommonError: Error{
    case netwrokError
    case configurationError
}

enum RequestError: Error{
    case malformedUrlError
    case networkError
}
