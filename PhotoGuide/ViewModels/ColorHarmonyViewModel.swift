//
//  ColorHarmonyViewModel.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 10/12/2025.
//

import SwiftUI

// MARK: - Types d’harmonies
enum HarmonyType: String, CaseIterable, Identifiable {
    case monochromatic = "Monochromatic"
    case analogous = "Analogous"
    case complementary = "Complementary"
    case splitComplementary = "Split Complementary"
    case triadic = "Triadic"
    case tetradic = "Tetradic"
    case square = "Square"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .monochromatic: return "circle.lefthalf.filled"
        case .analogous: return "circle.grid.2x1.left.filled"
        case .complementary: return "circle.circle.fill"
        case .splitComplementary: return "triangle.lefthalf.filled"
        case .triadic: return "triangle.fill"
        case .tetradic: return "square.fill"
        case .square: return "square.split.2x2"
        }
    }

    var shortLabel: String {
        switch self {
        case .monochromatic: return "Mono"
        case .analogous: return "Analog"
        case .complementary: return "Compl."
        case .splitComplementary: return "Split"
        case .triadic: return "Triadic"
        case .tetradic: return "Tet."
        case .square: return "Square"
        }
    }

}

class ColorHarmonyViewModel: ObservableObject {
    
    @Published var baseHue: Double = 0    // 0–360°
    @Published var harmony: HarmonyType = .analogous
    
    private func wrap(_ h: Double) -> Double {
        (h + 360).truncatingRemainder(dividingBy: 360)
    }
    
    // MARK: - Harmonies
    var monochromatic: [Double] {
        [baseHue]
    }
    
    var analogous: [Double] {
        [wrap(baseHue - 30), baseHue, wrap(baseHue + 30)]
    }
    
    var complementary: [Double] {
        [baseHue, wrap(baseHue + 180)]
    }
    
    var splitComplementary: [Double] {
        [
            baseHue,
            wrap(baseHue + 180 - 30),
            wrap(baseHue + 180 + 30)
        ]
    }
    
    var triadic: [Double] {
        [baseHue, wrap(baseHue + 120), wrap(baseHue + 240)]
    }
    
    var tetradic: [Double] {
        [
            baseHue,
            wrap(baseHue + 60),
            wrap(baseHue + 180),
            wrap(baseHue + 240)
        ]
    }
    
    var square: [Double] {
        [
            baseHue,
            wrap(baseHue + 90),
            wrap(baseHue + 180),
            wrap(baseHue + 270)
        ]
    }
    
    
    // MARK: - Résultat d’harmonie sélectionnée
    var activeHarmony: [Double] {
        switch harmony {
        case .monochromatic: return monochromatic
        case .analogous: return analogous
        case .complementary: return complementary
        case .splitComplementary: return splitComplementary
        case .triadic: return triadic
        case .tetradic: return tetradic
        case .square: return square
        }
    }
}

