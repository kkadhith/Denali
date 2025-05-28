//
//  FineTuneSettings.swift
//  Denali
//
//  Created by Adhith Karthikeyan on 4/5/25.
//


import SwiftUI


struct FineTuneOptions: View {

    let tracker: HikeDataManager
    @AppStorage("distanceFilter") private var distanceFilterValue: Double?
    @State private var tempVal: Double = 0.0
    
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        NavigationStack {
            List {
                Section (header: Text("Modify distance filter"), footer: Text("The minimum distance in meters before location is tracked.")){
                    HStack {
                        Text("Distance filter")
                        Spacer()
                        Text("\(Int(tempVal))")
                            .foregroundColor(.gray)
                    }
                    Slider(value: $tempVal, in: 0...10, step: 1) {
                        Text("Slider to modify distance filter")
                    }
                }

            }
            .navigationTitle("Adjust GPS")
            .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.primaryAction) {
                    Button("Save") {
                        tracker.modifyDistanceFilter(tempVal)
                        distanceFilterValue = tempVal
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            // distanceFilterValue = UserDefaults value (if exists)
            tempVal = distanceFilterValue ?? 0.0
        }
    }
}
