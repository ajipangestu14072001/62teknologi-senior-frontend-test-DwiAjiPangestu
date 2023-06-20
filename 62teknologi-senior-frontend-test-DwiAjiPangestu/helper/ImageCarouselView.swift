//
//  ImageCarouselView.swift
//  62teknologi-senior-frontend-test-DwiAjiPangestu
//
//  Created by Dwi Aji Pangestu on 20/06/23.
//

import Foundation
import SwiftUI

struct ImageCarouselView: View {
    let imageURLs: [String]
    
    var body: some View {
        TabView {
            ForEach(imageURLs, id: \.self) { imageURL in
                AsyncImage(url: URL(string: imageURL)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                    } else {
                        ProgressView()
                            .frame(height: 200)
                    }
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
        .frame(height: 200)
    }
}

