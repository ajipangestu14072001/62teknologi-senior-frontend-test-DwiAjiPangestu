//
//  DetailBusinessViewModel.swift
//  62teknologi-senior-frontend-test-DwiAjiPangestu
//
//  Created by Dwi Aji Pangestu on 20/06/23.
//

import Foundation

class DetailBusinessViewModel: ObservableObject {
    @Published var detailBusiness: DetailBusiness? = nil
    @Published var reviews: [ReviewElement] = []

    func fetchBusiness(with id: String) {
        Task {
            do {
                let apiResponse = try await fetchAPIResponse(with: id)
                DispatchQueue.main.async {
                    self.detailBusiness = apiResponse
                }
            } catch {
                print("Error fetching business detail: \(error)")
                DispatchQueue.main.async {
                    self.detailBusiness = nil
                }
            }
        }
    }

    private func fetchAPIResponse(with id: String) async throws -> DetailBusiness {
        guard let url = URL(string: "\(Constant.baseURL)\(id)") else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        var request = URLRequest(url: url)
        request.setValue(Constant.token, forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        let apiResponse = try JSONDecoder().decode(DetailBusiness.self, from: data)
        return apiResponse
    }
    
    func fetchReviews(with businessID: String) {
        Task {
            do {
                let apiResponse = try await fetchReviewsAPIResponse(with: businessID)
                DispatchQueue.main.async {
                    self.reviews = apiResponse.reviews
                }
            } catch {
                print("Error fetching reviews: \(error)")
                DispatchQueue.main.async {
                    self.reviews = []
                }
            }
        }
    }
    
    private func fetchReviewsAPIResponse(with businessID: String) async throws -> Review {
        guard let url = URL(string: "\(Constant.baseURL)\(businessID)/reviews") else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var request = URLRequest(url: url)
        request.setValue(Constant.token, forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let apiResponse = try JSONDecoder().decode(Review.self, from: data)
        return apiResponse
    }
}
