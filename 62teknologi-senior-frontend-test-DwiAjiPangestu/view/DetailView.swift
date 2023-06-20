//
//  DetailView.swift
//  62teknologi-senior-frontend-test-DwiAjiPangestu
//
//  Created by Dwi Aji Pangestu on 20/06/23.
//

import Foundation
import SwiftUI

struct DetailView: View {
    let businessID: String
    @StateObject private var viewModel = DetailBusinessViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 16) {
                if let detailBusiness = viewModel.detailBusiness {
                    ImageCarouselView(imageURLs: detailBusiness.photos)
                        .aspectRatio(contentMode: .fill)
                        .frame(height: geometry.size.height * 0.4)
                        .clipped()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(detailBusiness.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", detailBusiness.rating))
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        
                        Button(action: {
                            if let mapsURL = URL(string: "https://maps.google.com/?q=\(detailBusiness.coordinates.latitude),\(detailBusiness.coordinates.longitude)") {
                                UIApplication.shared.open(mapsURL)
                            }
                        }) {
                            Text("See on Google Maps")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                    
                    if !viewModel.reviews.isEmpty {
                        List(viewModel.reviews, id: \.id) { review in
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text(String(format: "%.1f", detailBusiness.rating))
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                    Text(review.user.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                }
                                Text(review.text)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .padding(.top, 4)
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                } else {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                Spacer()
            }
            .padding()
            .onAppear {
                viewModel.fetchBusiness(with: businessID)
                viewModel.fetchReviews(with: businessID)
            }
        }
    }
}





