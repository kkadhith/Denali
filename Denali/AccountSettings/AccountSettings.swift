//
//  AccountSettings.swift
//  Denali
//
//  Created by Adhith Karthikeyan on 4/5/25.
//


import SwiftUI
import UIKit

/*
 Settings
 1. Fine tune settings (location)
 2. Open system settings
 
 Misc.
 3. About
 
 */
struct SettingsPage: View {
    
    let tracker: HikeDataManager
    
    var body: some View {
        NavigationStack {
            
            List {
                
                Section (header: Text("App settings")){
                    
                    NavigationLink {
                        FineTuneOptions(tracker: tracker)
                    } label: {
                        
                        // TODO: Change this to its own view
                        HStack {
                            Image(systemName: "paperplane.fill")
                                .padding(5)
                                .background(.green)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                .foregroundStyle(.white)
                                .fontWeight(Font.Weight.bold)
                            Text("Location Tuning")
                        }
                        .frame(height: 40)
                    }
                    
                    
                    NavigationLink {
                        AboutView()
                    }
                    label: {
                        HStack {
                            Image(systemName: "person.fill")
                                .padding(5)
                                .background(.red)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                .foregroundStyle(.white)
                                .fontWeight(Font.Weight.bold)
                            Text("About")
                        }
                        .frame(height: 40)
                    }
                    
                    
                }
                
                Section(header: Text("General Settings")) {
                    
                    Button {
                        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsUrl)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "gearshape.fill")
                                .padding(5)
                                .background(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                .foregroundStyle(.white)
                                .fontWeight(Font.Weight.bold)
                            Text("System Settings")
                            
                            Spacer()
                            Image(systemName: "rectangle.portrait.and.arrow.forward")
                        }
                        .frame(height: 40)
                    }
                    .foregroundColor(.primary)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
