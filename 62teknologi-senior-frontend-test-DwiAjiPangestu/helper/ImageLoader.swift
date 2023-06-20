//
//  ImageLoader.swift
//  62teknologi-senior-frontend-test-DwiAjiPangestu
//
//  Created by Dwi Aji Pangestu on 20/06/23.
//

import Foundation
import UIKit
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage? = nil

    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, _ -> UIImage? in
                UIImage(data: data)
            }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loadedImage in
                self?.image = loadedImage
            }
            .store(in: &cancellables)
    }

    private var cancellables = Set<AnyCancellable>()
}
