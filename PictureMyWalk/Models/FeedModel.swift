//
//  FeedModel.swift
//  PictureMyWalk
//
//  Created by Rosa Meijers on 30/06/2023.
//

import Foundation

struct FeedModel: Codable {
    let photos: PhotoObject
    
    enum CodingKeys: String, CodingKey {
        case photos
    }
}

struct PhotoObject: Codable {
    let photo: [Photo]
}

struct Photo: Identifiable, Codable {
    let id, title, latitude, longitude: String
    let url: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, title, latitude, longitude
        case url = "url_z"
    }
}
