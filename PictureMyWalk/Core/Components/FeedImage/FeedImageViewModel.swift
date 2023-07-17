//
//  FeedImageViewModel.swift
//  PictureMyWalk
//
//  Created by Rosa Meijers on 04/07/2023.
//

import Foundation
import SwiftUI
import Combine

class FeedImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let photo: Photo
    private let dataService: FeedImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(photo: Photo) {
       self.photo = photo
       self.dataService = FeedImageService(photo: photo)
       addSubscribers()
       self.isLoading = true
    }
    
    private func addSubscribers() {
        dataService.$image
            .sink{[weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellables)
    }
}

