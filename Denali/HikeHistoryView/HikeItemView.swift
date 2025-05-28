//
//  HikeItemView.swift
//  Denali
//
//  Created by Adhith Karthikeyan on 4/3/25.
//


import SwiftUI
import CoreLocation
import MapKit
import Charts

struct altitudeItem: Identifiable {
    let id = UUID()
    let timeStamp: Date?
    let altitude: Double?
}

struct TripMapView: View {
    /*
     CoreData is based on NSSet, so we need to convert it to LocationPoint then
     back to CLLocationCoordinate2D
     */
    let trip: Trip
    
    
    
    var coordinates: [CLLocationCoordinate2D] {
        guard let points = trip.points as? Set<LocationPoint> else {
            return []
        }
        
        let coords = points.sorted {
            guard let time1 = $0.timestamp, let time2 = $1.timestamp else { return false }
            return time1 < time2
        }
        .map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        return coords
    }
    
    
    var altitudeItemList: [altitudeItem] {
        guard let points = trip.points as? Set<LocationPoint> else {
            return []
        }
        
        let sortedPoints = points.sorted { point1, point2 in
            guard let time1 = point1.timestamp, let time2 = point2.timestamp else {
                return false
            }
            return time1 < time2
        }
        
        var items: [altitudeItem] = []
        for point in sortedPoints {
            let item = altitudeItem(
                timeStamp: point.timestamp,
                altitude: point.altitude
            )
            items.append(item)
        }
        
        return items
    }
    
    func formatTime(_ elapsedTime: Double) -> String {
        let hours = Int(elapsedTime) / 3600
        let mins = Int(elapsedTime) / 60 % 60
        let seconds = Int(elapsedTime) % 60
        
        if (hours > 0) {
            return String(format: "%02d:%02d:%02d", hours, mins, seconds)
        }
        else {
            return String(format: "%02d:%02d", mins, seconds)
        }
    }

    
    var body: some View {
        
        ScrollView {
            VStack (alignment: .leading) {
                Text("Map Overview")
                    .font(Font.title2)
                    .fontDesign(.rounded)
                    .padding(.top, 12)
                    .padding(.bottom, 4)
                    .bold()
                
                    Map {
                        MapPolyline(coordinates: coordinates)
                            .stroke(.blue, lineWidth: 3)
                    }
                    .mapStyle(.imagery)
                    .frame(width: 350, height: 350)
                    .clipShape(RoundedRectangle(cornerRadius: 15))

                VStack (alignment: .leading) {
                    
    
                    Text("Stats")
                        .font(Font.title2)
                        .fontDesign(.rounded)
                        .padding(.bottom, 4)
                        .bold()
                    
                    HStack {
                        Image(systemName: "stopwatch")
                            .font(.system(size: 24))
                            .frame(width: 40, height: 40)
                            .padding(.leading, 8)
                        
                        VStack (alignment: .leading) {
                            Text("Time Taken")
                                .font(.subheadline)
                            
                            Text("\(formatTime(trip.timeTaken))")
                                .font(.headline)
                        }
                        
                        Spacer()
                    }
                    .frame(width: 350)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    HStack {
                        Image(systemName: "hare")
                            .font(.system(size: 24))
                            .frame(width: 40, height: 40)
                            .padding(.leading, 8)
                        
                        VStack (alignment: .leading) {
                            Text("Top Speed")
                                .font(.subheadline)
                            
                            Text(String(Int(trip.topSpeed)) + String(" m/s"))
                                .font(.headline)
                        }
                        
                        Spacer()
                    }
                    .frame(width: 350)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    HStack {
                        Image(systemName: "mountain.2")
                            .font(.system(size: 24))
                            .frame(width: 40, height: 40)
                            .padding(.leading, 8)
                        
                        VStack (alignment: .leading) {
                            Text("Peak Altitude")
                                .font(.subheadline)
                            
                            Text(String(Int(trip.peakAltitude)) + String(" meters"))
                                .font(.headline)
                        }
                        
                        Spacer()
                    }
                    .frame(width: 350)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    HStack {
                        Image(systemName: "trophy")
                            .font(.system(size: 24))
                            .frame(width: 40, height: 40)
                            .padding(.leading, 8)
                        
                        VStack (alignment: .leading) {
                            Text("Total Distance")
                                .font(.subheadline)
                            Text(String(Int(trip.totalDistance)) + String(" meters"))
                                .font(.headline)
                        }
                        
                        Spacer()
                    }
                    .frame(width: 350)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .navigationTitle(trip.title ?? "Trip Overview")
        }
        .scrollIndicators(.hidden)
    }
}
