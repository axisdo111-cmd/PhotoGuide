//
//  ColorHarmonyWheel.swift
//  PhotoGuide
//
//  Rendu complet : cercle chromatique + points d’harmonie + slider + barre d’harmonies
//

import SwiftUI

struct ColorHarmonyWheel: View {
    
    // ViewModel principal
    @ObservedObject var vm: ColorHarmonyViewModel
    
    // Rayon pour les points
    private let pointRadius: CGFloat = 100
    
    var body: some View {
        VStack(spacing: 16) {
            
            // MARK: - Cercle chromatique + points
            ZStack {
                
                spectrumCircle
                
                harmonyPoints
            }
            .frame(width: 260, height: 260)
            
            
            // MARK: - Slider Hue
            hueSlider
            
            
            // MARK: - Barre d’harmonies
            harmonySelector
        }
        .padding(.bottom, 4)
    }
}

//------------------------------------------------------
// MARK: - CERCLE CHROMATIQUE
//------------------------------------------------------

private extension ColorHarmonyWheel {
    
    var spectrumCircle: some View {
        Circle()
            .strokeBorder(
                AngularGradient(
                    gradient: Gradient(colors: generateSpectrum()),
                    center: .center
                ),
                lineWidth: 28
            )
    }
    
    /// Génère le spectre complet (0° → 360°)
    func generateSpectrum() -> [Color] {
        stride(from: 0.0, through: 360.0, by: 5).map {
            Color(hue: $0 / 360.0, saturation: 1, brightness: 1)
        }
    }
}

//------------------------------------------------------
// MARK: - POINTS D’HARMONIE
//------------------------------------------------------

private extension ColorHarmonyWheel {
    
    var harmonyPoints: some View {
        ForEach(vm.activeHarmony, id: \.self) { hue in
            let angle = Angle(degrees: hue)
            
            Circle()
                .fill(Color(hue: hue/360, saturation: 1, brightness: 1))
                .frame(width: 24, height: 24)
                .offset(
                    x: cos(angle.radians) * pointRadius,
                    y: sin(angle.radians) * pointRadius
                )
        }
    }
}

//------------------------------------------------------
// MARK: - SLIDER HUE
//------------------------------------------------------

private extension ColorHarmonyWheel {
    
    var hueSlider: some View {
        VStack(spacing: 6) {
            Slider(value: $vm.baseHue, in: 0...360)
                .tint(.white)
            
            Text("Hue : \(Int(vm.baseHue))°")
                .font(.caption)
                .foregroundColor(.white.opacity(0.9))
        }
        .padding(.horizontal)
    }
}

// ------------------------------------------------------
// MARK: - SELECTEUR D’HARMONIE (PREMIUM)
// ------------------------------------------------------

private extension ColorHarmonyWheel {
    
    var harmonySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {

                ForEach(HarmonyType.allCases) { harmony in
                    
                    let isSelected = vm.harmony == harmony

                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            vm.harmony = harmony
                        }
                    } label: {

                        VStack(spacing: 6) {

                            // ● Icône ronde premium
                            ZStack {
                                Circle()
                                    .fill(isSelected
                                          ? Color.blue.opacity(0.85)
                                          : Color.white.opacity(0.12))
                                    .frame(width: 44, height: 44)

                                if harmony == .tetradic {
                                    TetrahedronIcon()
                                        .frame(width: 22, height: 22)   // ✅ contrainte
                                        .foregroundColor(.white)
                                        .clipped()                      // ✅ coupe ce qui dépasse
                                } else {
                                    Image(systemName: harmony.iconName)
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(isSelected ? .white : .white.opacity(0.8))
                                }
                            }
                            // Animation douce
                            .scaleEffect(isSelected ? 1.1 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
                            
                            .frame(width: 44, height: 44)               // ✅ cadre FINAL
                            .clipShape(Circle())                         // ✅ sécurité

                            // ● Label
                            Text(harmony.shortLabel)
                                .font(.caption2)
                                .foregroundColor(.white.opacity(isSelected ? 1 : 0.6))
                        }
                        .padding(.horizontal, 4)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 4)
            .padding(.bottom, 6)
        }
        .frame(height: 95)   // ← permet d'avoir un espace réel sous la roue !
        .offset(y: -18)     // ← 🔼 remonte uniquement la barre des harmonies
    }
}


