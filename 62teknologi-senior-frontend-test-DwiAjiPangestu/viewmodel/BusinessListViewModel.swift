//
//  BusinessListViewModel.swift
//  62teknologi-senior-frontend-test-DwiAjiPangestu
//
//  Created by Dwi Aji Pangestu on 20/06/23.
//

import Foundation

class BusinessListViewModel: ObservableObject {
    @Published var businesses: [Business] = []
    @Published var currentPage = 1
    @Published var totalResults = 0
    @Published var isLoading = false

    func resetPagination() {
        currentPage = 1
        totalResults = 0
        businesses.removeAll()
    }

    func fetchBusinesses(with searchTerm: String? = nil) {
        guard !isLoading else { return }

        isLoading = true

        Task {
            do {
                let apiResponse = try await fetchAPIResponse(with: searchTerm)
                DispatchQueue.main.async {
                    self.businesses.append(contentsOf: apiResponse.businesses)
                    self.totalResults = apiResponse.total
                    self.isLoading = false
                    self.currentPage += 1
                }
            } catch {
                print("Error fetching businesses: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }

    func loadMoreIfNeeded(currentItem: Business) {
        guard !isLoading else { return }

        let thresholdIndex = businesses.index(businesses.endIndex, offsetBy: -5)
        if businesses.firstIndex(where: { $0.id == currentItem.id }) == thresholdIndex {
            if businesses.count < totalResults {
                fetchBusinesses()
            }
        }
    }

    private func fetchAPIResponse(with searchTerm: String?) async throws -> APIResponse {
        guard var urlComponents = URLComponents(string: "\(Constant.baseURL)search") else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        var queryItems: [URLQueryItem] = []
        if let searchTerm = searchTerm, !searchTerm.isEmpty {
            queryItems.append(URLQueryItem(name: "term", value: searchTerm))
        }
        queryItems.append(URLQueryItem(name: "latitude", value: "37.786882"))
        queryItems.append(URLQueryItem(name: "longitude", value: "-122.399972"))
        queryItems.append(URLQueryItem(name: "offset", value: String((currentPage - 1) * 20)))

        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        var request = URLRequest(url: url)
        request.setValue(Constant.token, forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
        return apiResponse
    }
}
