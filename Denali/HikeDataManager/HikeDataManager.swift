//
//  HikeDataManager.swift
//  Denali
//
//  Created by Adhith Karthikeyan on 2/20/25.
//

import Foundation
import CoreLocation
import CoreData
import SwiftUI

class HikeDataManager: NSObject, CLLocationManagerDelegate, ObservableObject {

    var GPSManager = CLLocationManager()
    
    @Published var locationAuthorizationStatus: CLAuthorizationStatus?
    @Published var tripLocationPoints: [CLLocation?] = []
    private var trackingStartTime: Date?
    private var firstPoint: Bool = true

    private var prevPoint: CLLocation? = nil
    
    override init() {
        super.init()
        GPSManager.delegate = self
        locationAuthorizationStatus = GPSManager.authorizationStatus
        
//        if UserDefaults.standard.object(forKey: "distanceFilter") == nil {
//            GPSManager.distanceFilter = 5
//        }
        if UserDefaults.standard.object(forKey: "distanceFilter") != nil {
            GPSManager.distanceFilter = UserDefaults.standard.double(forKey: "distanceFilter")
        }
    }
    
    func modifyDistanceFilter(_ newFilterValue: Double) {
        if (newFilterValue == 0) {
            GPSManager.distanceFilter = kCLDistanceFilterNone
            return
        }
        GPSManager.distanceFilter = newFilterValue
    }
    
    func beginTracking() {
        trackingStartTime = Date()
        GPSManager.startUpdatingLocation()
    }
    
    func pauseTracking() {
        GPSManager.stopUpdatingLocation()
    }
    
    func resumeTracking() {
        GPSManager.startUpdatingLocation()
    }
    
    func requestLocationPermission() {
        GPSManager.requestWhenInUseAuthorization()
    }
    
    func stopTracking(context: NSManagedObjectContext, title: String? = nil, time: Double?) {
        
        GPSManager.stopUpdatingLocation()
        
        let trip = Trip(context: context)
        trip.startDate = trackingStartTime
        trip.endDate = Date()
        trip.title = title
        trip.timeTaken = Double(time ?? 0.0)
        
        let totalPoints: Double = Double(tripLocationPoints.count)
        
        var speedSum: Double = 0.0
        var altitudeSum: Double = 0.0
        
        var topSpeed: Double = 0.0
        var peakAltitude: Double = 0.0
        
        var totalDistance: Double = 0.0
        
        
        
        for location in tripLocationPoints {
            guard let location = location else {continue}
            
            let point = LocationPoint(context: context)
            point.latitude = location.coordinate.latitude
            point.longitude = location.coordinate.longitude
            point.altitude = location.altitude
            point.timestamp = location.timestamp
            
            let distance: Double = prevPoint?.distance(from: location) ?? 0.0
            
            totalDistance += distance
            prevPoint = location
            

            speedSum += location.speed
            altitudeSum += location.altitude
            
            topSpeed = max(topSpeed, location.speed)
            peakAltitude = max(peakAltitude, location.altitude)
            
            point.trip = trip
        }
        
        var averageSpeed = speedSum / totalPoints
        if (averageSpeed < 0) {
            averageSpeed = 0
        }

        let averageAltitude = altitudeSum / totalPoints

        
        trip.averageAltitude = averageAltitude
        trip.averageSpeed = averageSpeed
        
        trip.topSpeed = topSpeed
        trip.peakAltitude = peakAltitude
        
        trip.totalDistance = totalDistance
        
        
        do {
            try context.save()
            tripLocationPoints.removeAll()
            trackingStartTime = nil
        } catch {
            print("error saving trip: \(error)")
        }
    }
 
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let pt = locations.last {
            print("current speed: \(pt.speed)")
        }
        tripLocationPoints.append(locations.last)
        if (firstPoint) {
            prevPoint = locations.last
        }
    }
    

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        if status == .authorizedWhenInUse {
            locationAuthorizationStatus = .authorizedWhenInUse
        }
        else if status == .denied {
            locationAuthorizationStatus = .denied
        }
        else if status == .notDetermined {
            locationAuthorizationStatus = .notDetermined
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

