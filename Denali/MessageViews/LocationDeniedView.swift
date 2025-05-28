//
//  LocationDeniedView.swift
//  DenaliTestingEnv
//
//  Created by Adhith Karthikeyan on 4/9/25.
//

import SwiftUI

struct LocationDeniedView: View {
    
    let tracker: HikeDataManager
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 100))
                .foregroundStyle(.red)
            
            Text("Location Services Disabled")
                .font(.title2)
                .bold()
            
            
            Text("Please enable location services to use Denali. Location data is stored entirely on your device.")
                .font(.caption)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .frame(width: 300)
            
            Button("Enable Location Services") {
                tracker.requestLocationPermission()
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
}
