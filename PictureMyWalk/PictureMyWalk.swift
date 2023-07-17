//
//  PictureMyWalk.swift
//  PictureMyWalk
//
//  Created by Rosa Meijers on 30/06/2023.
//

import SwiftUI

@main
struct PictureMyWalkApp: App {
    @StateObject private var vm = FeedViewModel(_feedDataService: FeedDataService(), _locationManager: LocationManager())
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                FeedView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
