//
//  LoadingView.swift
//  Modern-SwiftUI-MVVM-Tests
//
//  Created by Burhan Aras on 28.08.2021.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView().padding()
            Text("Loading")
        }
        .padding()
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
