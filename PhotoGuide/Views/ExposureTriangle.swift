//
//  ExposureTriangle.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 10/12/2025.
//

import SwiftUI

struct ExposureTriangle: View {
    
    @ObservedObject var vm: ExposureViewModel

    var body: some View {
        VStack(spacing: 16) {
            
            // --- EV GLOBAL ---
            Text("Δ EV : \(vm.totalEV, specifier: "%.2f")")
                .font(.title2)
                .bold()
                .padding(.top)

            // --- ISO ---
            VStack(alignment: .leading) {
                Text("ISO : \(Int(vm.iso))")
                    .font(.caption)

                Slider(value: $vm.iso, in: 50...6400, step: 50)
            }

            // --- VITESSE (slider discret basé sur index) ---
            VStack(alignment: .leading) {
                Text("Vitesse : \(formattedSpeed(vm.shutter))")
                    .font(.caption)

                Slider(
                    value: Binding(
                        get: { Double(vm.shutterIndex) },
                        set: { vm.shutterIndex = Int($0.rounded()) }
                    ),
                    in: 0...Double(vm.shutterStops.count - 1),
                    step: 1
                )
            }

            // --- OUVERTURE ---
            VStack(alignment: .leading) {
                Text("Ouverture : f/\(vm.aperture, specifier: "%.1f")")
                    .font(.caption)

                Slider(
                    value: Binding(
                        get: { Double(vm.apertureIndex) },
                        set: { vm.apertureIndex = Int($0.rounded()) }
                    ),
                    in: 0...Double(vm.apertureStops.count - 1),
                    step: 1
                )

            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding()
    }

    // Affichage propre des vitesses
    func formattedSpeed(_ s: Double) -> String {
        if s >= 1 {
            return "\(Int(s)) s"
        } else {
            return "1/\(Int(1/s)) s"
        }
    }
}
