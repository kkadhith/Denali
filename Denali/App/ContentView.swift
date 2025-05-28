//
//  ContentView.swift
//  DenaliTestingEnv
//
//  Created by Adhith Karthikeyan on 4/6/25.
//  Licensed under Apache License v2.0
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var HikeLocationController = HikeDataManager()
    
    var body: some View {
        TabView {
            Tab("History", systemImage: "book") {
                LocationView(tracker: HikeLocationController)
            }
            Tab("Hike Map", systemImage: "map") {
                WalkingMapView(tracker: HikeLocationController)
            }
            Tab("App Settings", systemImage: "gearshape.2.fill") {
                SettingsPage(tracker: HikeLocationController)
            }
        }
    }
}

#Preview {
    ContentView()
}
