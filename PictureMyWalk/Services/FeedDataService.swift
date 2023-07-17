//
//  FeedDataService.swift
//  PictureMyWalk
//
//  Created by Rosa Meijers on 30/06/2023.
//

import Foundation
import Combine

final class FeedDataService {
    @Published var flickrFeed: [Photo] = []
    
    private var feedSubscription: AnyCancellable?
    
    func getFeed(userLocation: UserLocation) {
        let url = generateRequestURL(location: userLocation)
        
        feedSubscription = NetworkingManager.download(url: url)
            .decode(type: FeedModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedFeed) in
                let photosArray = returnedFeed.photos.photo

                for photo in photosArray {
                    var sameID = false
                    for feed in self!.flickrFeed {
                        if (feed.id == photo.id){
                            sameID = true
                        }
                    }

                    // Only add feed that does not yet exist in our array
                    if(!sameID){
                        self?.flickrFeed.append(photo)
                        break
                    }
                }
                self?.feedSubscription?.cancel()
            })
    }
    
    private func generateRequestURL(location: UserLocation) -> URL {
        var components = URLComponents(string: FlickrAPI.baseURLString)
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "accuracy": "14", // accuracy level of the location
            "method": "flickr.photos.search", // search method
            "has_geo": "1", // fetch only photos that have been geotagged
            "geo_context": "2", // context set to outdoors
            "format": "json",
            "nojsoncallback": "1",
            "text": "outdoors", // search text set to outdoors
            "radius": "10", // radius of 10 km
            "api_key": FlickrAPI.apiKey,
            "per_page": "30",
            "lat": String(location.latitude), // search for photos based on the users location
            "lon": String(location.longitude),
            "extras": "url_z, geo",
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        components!.queryItems = queryItems
        
        return components!.url!
    }
}
