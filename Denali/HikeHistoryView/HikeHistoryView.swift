//
//  HikeHistoryView.swift
//  Denali
//
//  Created by Adhith Karthikeyan on 4/3/25.
//

import SwiftUI
import CoreLocation
import MapKit


enum TimeFilterOption {
    case all, week, month, year
}


struct LocationView: View {
    
    let tracker: HikeDataManager
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // static so we can initialize it before fetchrequest
    static let sortByDate = NSSortDescriptor(keyPath: \Trip.startDate, ascending: false)
    
    @FetchRequest(sortDescriptors: [sortByDate]) private var trips: FetchedResults<Trip>
    
    private var filteredTrips: [Trip] {
        let calendar = Calendar.current
        let currentDate = Date()
        
        switch timeFilter {
        case .all:
            return Array(trips)
        case .week:
            guard let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: currentDate) else {
                        return Array(trips)
                    }
            return trips.filter { trip in
                        guard let tripStart = trip.startDate else { return false }
                        return tripStart >= oneWeekAgo
                    }
        case .month:
            guard let oneWeekAgo = calendar.date(byAdding: .day, value: -30, to: currentDate) else {
                        return Array(trips)
                    }
            return trips.filter { trip in
                        guard let tripStart = trip.startDate else { return false }
                        return tripStart >= oneWeekAgo
                    }
        case .year:
            guard let oneWeekAgo = calendar.date(byAdding: .day, value: -365, to: currentDate) else {
                        return Array(trips)
                    }
            return trips.filter { trip in
                        guard let tripStart = trip.startDate else { return false }
                        return tripStart >= oneWeekAgo
                    }
        }
    }
    
    
    
    private func deleteTrip(set: IndexSet) {
        // get index of trip were trying to delete
        // indexSet might be empty (or in theory many indicies)
        
        if let idx = set.first {
            viewContext.delete(trips[idx])
            do {
                try viewContext.save()
            }
            catch {
                print("error found: \(error)")
            }
        }
        else {
            print("No index found.")
        }
    }
    
    @State private var timeFilter: TimeFilterOption = .week
    
    // TODO: Understand namespace prop wrapper and how it affects animation:
    // https://developer.apple.com/documentation/swiftui/view/navigationtransition(_:)
//    @Namespace private var namespace
    
    var body: some View {
        VStack {
            switch tracker.locationAuthorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                    NavigationStack {
                        List {
                            Picker("Date Filter", selection: $timeFilter) {
                                Text("Week").tag(TimeFilterOption.week)
                                Text("Month").tag(TimeFilterOption.month)
                                Text("Year").tag(TimeFilterOption.year)
                                Text("All").tag(TimeFilterOption.all)
                            }
                            .pickerStyle(.segmented)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
            
                            
                            ForEach(filteredTrips, id: \.startDate) { trip in
                                NavigationLink {
                                    TripMapView(trip: trip)
//                                        .navigationTransition(.zoom(sourceID: "trip_\(trip.startDate?.timeIntervalSince1970 ?? 0)", in: namespace))
                                } label: {
                                    TripListItem(tripItemTitle: trip.title ?? "", tripDate: trip.endDate ?? Date(), tripAverageAltitude: trip.averageAltitude, tripAverageSpeed: trip.averageSpeed)
//                                        .matchedTransitionSource(id: "trip_\(trip.startDate?.timeIntervalSince1970 ?? 0)", in: namespace)
                                }
                            }
                            .onDelete(perform: deleteTrip)
                        }
                        .listRowSpacing(7)
                        .navigationTitle("Past Hikes")
                    }
            case .notDetermined, .restricted, .denied, .none, .some(_):
                LocationDeniedView(tracker: tracker)
            }
        }
    }
}

//#Preview {
//    LocationView()
//}
