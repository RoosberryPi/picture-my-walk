//
//  FeedImageService.swift
//  PictureMyWalk
//
//  Created by Rosa Meijers on 04/07/2023.
//

import Foundation
import SwiftUI
import Combine

final class FeedImageService {
    @Published var image: UIImage? = nil
    
    private let photo: Photo
    private var imageSubscription: AnyCancellable?
    private let imageName: String

    init(photo: Photo) {
        self.photo = photo
        self.imageName = photo.id
        downloadFeedImage()
    }
    
    private func downloadFeedImage() {  
        guard let photoUrl = photo.url, let url = URL(string: photoUrl) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                guard let self = self, let downloadedImage = returnedImage else { return }
                self.image = downloadedImage
                self.imageSubscription?.cancel()
            })
    }
}

