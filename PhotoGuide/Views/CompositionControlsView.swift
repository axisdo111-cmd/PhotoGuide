//
//  CompositionControlsView.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 10/12/2025.
//

import SwiftUI

/// Panneau de contrôle des overlays (grille + couleur + opacité)
struct CompositionControlsView: View {
    @ObservedObject var vm: CompositionViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            
            // MARK: - Picker horizontal
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(CompositionMode.allCases) { mode in
                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                vm.mode = mode
                            }
                        } label: {
                            Text(mode.rawValue)
                                .font(.caption2)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(vm.mode == mode ? Color.accentColor : Color.black.opacity(0.4))
                                )
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.plain)
                        .contentShape(Capsule())
                    }
                }
                .padding(.horizontal)
            }
            
            // MARK: - Golden Spiral options
            if vm.mode == .goldenSpiral {

                VStack(alignment: .leading, spacing: 8) {

                    Toggle("Rectangles d’or", isOn: $vm.spiralConfig.showRectangles)
                        .toggleStyle(SwitchToggleStyle(tint: .yellow))

                    HStack {
                        Text("Précision")
                        Spacer()
                        Text("\(vm.spiralConfig.samplesPerArc)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Slider(
                        value: Binding(
                            get: { Double(vm.spiralConfig.samplesPerArc) },
                            set: { vm.spiralConfig.samplesPerArc = Int($0) }
                        ),
                        in: 8...64,
                        step: 4
                    )

                    Toggle("Miroir", isOn: $vm.spiralConfig.mirror)

                }
                .padding(.horizontal)
            }
            
            // MARK: - Opacité
            HStack {
                Text("Opacité")
                Slider(value: $vm.lineOpacity, in: 0.1...1)
            }
            .padding(.horizontal)
            
            // MARK: - Épaisseur
            HStack {
                Text("Épaisseur")
                Slider(value: $vm.lineWidth, in: 0.5...4)
            }
            .padding(.horizontal)
            
            // MARK: - Couleur
            HStack {
                Text("Couleur")
                ColorPicker("", selection: $vm.lineColor)
                    .labelsHidden()
            }
            
            .padding(.horizontal)
            
        }
        .padding(10)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding()
    }
}


