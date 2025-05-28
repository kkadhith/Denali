//
//  TripMapView.swift
//  HikePal
//
//  Created by Adhith Karthikeyan on 2/17/25.
//

import SwiftUI
import Charts
import MapKit
import AirAlert


struct WalkingMapView: View {
    @State private var isStarted = false
    
    @State private var showAlert = false
    @State private var txt = ""
    
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    
    @Environment(\.managedObjectContext) private var viewContext
    
    let tracker: HikeDataManager
    
    
    func startTimer() {
        tracker.beginTracking()
        isStarted = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedTime += 1
        }
    }
    
    func pauseAndAlert() {
        tracker.pauseTracking()
        timer?.invalidate()
        showAlert = true
    }
    func continueTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedTime += 1
        }
        tracker.resumeTracking()
        showAlert = false
    }
    
    func saveTimer() {
        isStarted = false
        showAlert = false
        
        if (txt == "") {
            txt = "Untitled Hike"
        }

        tracker.stopTracking(context: viewContext, title: String(txt), time: elapsedTime)
        txt = ""
        timer = nil
        elapsedTime = 0
    }
    
    func formatTime(_ elapsedTime: TimeInterval) -> String {
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
    
    @State private var userPosition: MapCameraPosition = .userLocation(fallback: .automatic)

    
    var body: some View {
        switch tracker.locationAuthorizationStatus {
        case .notDetermined, .restricted, .denied, .none:
            ZStack {
                Map()
                
                LocationDeniedView(tracker: tracker)
                    .frame(width: 300, height: 300)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        
        case .authorizedAlways, .authorizedWhenInUse:
            ZStack {
                Map(position: $userPosition) {
                    UserAnnotation()
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Button(action:{
                            
                            if (!isStarted) {
                                startTimer()
                            }
                            else {
                                pauseAndAlert()
                            }
                            
                            }) {
                            Text(isStarted ? "Stop" : "Start")
                                .frame(width: 50)
                        }
                        .font(.title2)
                        .tint(isStarted ? .red : .green)
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .controlSize(.large)
                        .padding(.leading)
                        
                        
                        Spacer()
                        
                        Text(formatTime(elapsedTime))
                            .font(.title2)
                            .frame(width: 90)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .padding(.trailing)
                    }
                    .padding(.vertical)
                    .background(Color(.systemBackground).opacity(0.8))
                }
            }
            .ignoresSafeArea(.keyboard)
            .airAlert(isPresented: $showAlert, textString: $txt, title: "Save hike?", mainButtonLabel: "OK", secondButtonLabel: "Cancel", textFieldLabel: "Hike title (e.g. Denali)", mainButtonAction: {saveTimer()}, secondButtonAction: {continueTimer()})
            
        case .some(_):
            ZStack {
                LocationDeniedView(tracker: tracker)
                Map()
            }
        }
    }
}
