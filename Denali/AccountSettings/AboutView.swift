//
//  AboutView.swift
//  Denali
//
//  Created by Adhith Karthikeyan on 4/5/25.
//

import SwiftUI


struct AboutView: View {
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "figure.hiking")
                            .font(.system(size: 70))
                        
                        Text("Denali")
                            .font(.title)
                            .bold()
                        
                        Text("v1.0")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                }
            }
            
            Section("Open Source Libraries") {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Denali uses the following frameworks and open source packages:")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Group {
                        Text("• AirAlert")
                        Text("• SwiftUI")
                        Text("• UIKit")
                    }
                    .font(.subheadline)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Acknowledgements")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AboutView()
}


