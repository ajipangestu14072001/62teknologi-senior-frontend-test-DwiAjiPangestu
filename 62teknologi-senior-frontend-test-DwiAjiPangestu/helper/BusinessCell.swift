//
//  BusinessCell.swift
//  62teknologi-senior-frontend-test-DwiAjiPangestu
//
//  Created by Dwi Aji Pangestu on 20/06/23.
//

import Foundation
import SwiftUI
import Combine

struct BusinessCell: View {
    let business: Business
    @StateObject private var imageLoader = ImageLoader()

    var body: some View {
        HStack(spacing: 16) {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .clipped()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(business.name)
                    .font(.headline)
                    .lineLimit(2)
                Text(business.categories.map { $0.title }.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                Text(business.location!.displayAddress.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
        }
        .onAppear {
            imageLoader.loadImage(from: business.imageURL)
        }
    }
}

