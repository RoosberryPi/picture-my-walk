//
//  PreviewProvider.swift
//  PictureMyWalk
//
//  Created by Rosa Meijers on 03/07/2023.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    
    let feedVM = FeedViewModel(_feedDataService: FeedDataService(), _locationManager: LocationManager())

    let photo = Photo(id: "1", title: "Test photo", latitude: "52.377956", longitude: "4.897070", url: "https://live.staticflickr.com/5175/5490539789_e4cbb79814_z.jpg")
}


