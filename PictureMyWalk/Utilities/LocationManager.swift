//
//  LocationManager.swift
//  PictureMyWalk
//
//  Created by Rosa Meijers on 04/07/2023.
//

import CoreLocation

// MARK: Protocol
protocol LocationDelegate {
    func didPassHundredMetres(location: UserLocation)
    func didCalculateDistance(distance: Double)
}

final class LocationManager: NSObject, ObservableObject {
    private let locationManager: CLLocationManager
    private var firstLocation: CLLocation?
    private var locationsArray: [CLLocation] = []
    private var lastCalculatedTotal = 0.0
    private var range: ClosedRange<Int> = 0...99
    private var totalDistance = 0.0
    
    var delegate: LocationDelegate?
    
    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        super.init()
        locationManager.delegate = self
    }
    
    //MARK: Class methods
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation(){
        locationManager.stopUpdatingLocation()
        firstLocation =  nil
        locationsArray.removeAll()
        totalDistance = 0.0
        range = 0...99
    }
    
    private func calculateTotalDistance() {
        let distanceLastTwoPoints = locationsArray[locationsArray.count-1].distance(from: locationsArray[locationsArray.count-2])
        totalDistance += distanceLastTwoPoints
    }
    
    private func didPassMultitudeOfHundredMeters() -> Bool {
        // Calculate the range of the total distance
        let dividedNumber = totalDistance / 100.0
        let start: Int = Int(dividedNumber.rounded(.down) * 100)
        let end: Int = Int(start + 100)
        let currentRange = (start)...end-1

        if range != currentRange {
            // New range of a multitude of 100 detected
            range = currentRange
            return true
        }
        return false
    }
}

// MARK: CLLocation Manager delegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !locations.isEmpty else { return }
        
        let currentLocation = locations[0]
        locationsArray.append(currentLocation)

        if firstLocation == nil {
            firstLocation = currentLocation
        } else {
            if (locationsArray.count >= 2) {
                calculateTotalDistance()
                
                delegate?.didCalculateDistance(distance: totalDistance)
                            
                // clear the array because we don't need the values anymore
                self.locationsArray.removeAll()
                    
                if didPassMultitudeOfHundredMeters() {
                    delegate?.didPassHundredMetres(location: UserLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude))
                }
            }
        }
    }
}
