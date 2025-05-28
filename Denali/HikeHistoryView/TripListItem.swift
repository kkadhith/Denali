//
//  TripListItem.swift
//  Denali
//
//  Created by Adhith Karthikeyan on 4/3/25.
//

import SwiftUI


struct MockTripItem {
    let tripItemTitle: String
    let timeTaken: Double
    let tripDate: Date
    let tripAlt: Double
    let tripSpeed: Double
}

var MockTripItems: [MockTripItem] = [
    MockTripItem(tripItemTitle: "Trip1", timeTaken: 0.0, tripDate: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), tripAlt: 5.0, tripSpeed: 10.0),
    MockTripItem(tripItemTitle: "Trip2", timeTaken: 0.0, tripDate: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(), tripAlt: 2.0, tripSpeed: 12.0),
    MockTripItem(tripItemTitle: "Trip3", timeTaken: 0.0, tripDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date(), tripAlt: 1.0, tripSpeed: 17.0),
    MockTripItem(tripItemTitle: "Trip4", timeTaken: 0.0,  tripDate: Calendar.current.date(byAdding: .day, value: 6, to: Date()) ?? Date(), tripAlt: 6.0, tripSpeed: 7.0)
]

struct LView: View {
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(MockTripItems, id: \.tripDate) { data in
                    NavigationLink {
                        Text("Destination")
                    } label: {
                        TripListItem(tripItemTitle: data.tripItemTitle, tripDate: data.tripDate, tripAverageAltitude: data.tripAlt, tripAverageSpeed: data.tripSpeed)
                    }

                }
            }
            .listRowSpacing(7)
            
        }
    }
}

struct TripListItem: View {
    
    let tripItemTitle: String
    let tripDate: Date
    let tripAverageAltitude: Double
    let tripAverageSpeed: Double
    
    var body: some View {
        HStack {
            VStack (alignment: .leading, spacing: 10) {
                Text(tripItemTitle)
                    .font(.headline)
                
                Text(tripDate, style: .date)
                    .font(.caption)
            }
            
            Spacer()
        
            VStack (spacing: 9) {
                    
                Label {
                    Text("Speed: \(String(format: "%.1f", tripAverageSpeed))")
                        .font(.callout)
                } icon: {
                    Image(systemName: "speedometer")
                        .foregroundStyle(.blue)
                }

                Label {
                    Text("Altitude \(String(format: "%.1f", tripAverageAltitude))")
                        .font(.callout)
                } icon: {
                    Image(systemName: "mountain.2")
                        .foregroundStyle(.green)
                }
            }
        }
        .frame(minHeight: 75)
    }
}

#Preview {
    LView()
}
