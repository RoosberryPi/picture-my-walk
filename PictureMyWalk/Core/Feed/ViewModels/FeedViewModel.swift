//
//  FeedViewModel.swift
//  PictureMyWalk
//
//  Created by Rosa Meijers on 30/06/2023.
//

import Foundation
import Combine

class FeedViewModel: ObservableObject {
    @Published var flickrFeed: [Photo] = []
    @Published var walkedDistance = 0.0
    
    private var feedDataService: FeedDataService? = nil
    private var locationManager: LocationManager? = nil
    private var cancellables = Set<AnyCancellable>()
    
    init(_feedDataService: FeedDataService, _locationManager: LocationManager) {
        feedDataService = _feedDataService
        locationManager = _locationManager
        locationManager?.delegate = self
    }
    
    func walkIsStarted() {
        locationManager?.startUpdatingLocation()
    }
    
    func walkIsEnded() {
        walkedDistance = 0.0
        locationManager?.stopUpdatingLocation()
    }
    
    func resetPhotos() {
        feedDataService?.flickrFeed.removeAll()
    }
    
    private func addSubscribers(location: UserLocation) {        
        feedDataService?.$flickrFeed
            .sink { [weak self] (returnedFeed) in
                self?.flickrFeed = returnedFeed
            }
            .store(in: &cancellables)
    }
}

extension FeedViewModel: LocationDelegate {
    func didPassHundredMetres(location: UserLocation) {
        addSubscribers(location: location)
        feedDataService?.getFeed(userLocation: location)
    }

    func didCalculateDistance(distance: Double) {
        walkedDistance = distance
    }
}
