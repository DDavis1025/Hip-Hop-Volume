//
//  ImageView.swift
//  Test
//
//  Created by Dillon Davis on 3/13/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import SwiftUI

struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader

    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }

    var body: some View {

        Image(uiImage: imageLoader.image ?? UIImage() )
                .resizable()
                .aspectRatio(contentMode: .fit)
//                .frame(width:100, height:100)
    }
}
