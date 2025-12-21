//
//  CompositionMode.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 10/12/2025.
//

import Foundation

enum CompositionMode: String, CaseIterable, Identifiable {
    
    case ruleOfThirds
    case goldenRatio
    case goldenSpiral
    case goldenTriangle
    case fibonacciMatrix
    case fibonacciDiagonals
    case harmonicArmature
    case dynamicSymmetryRoot2
    case dynamicSymmetryRoot3
    case dynamicSymmetryRoot5       // ← ⭐ Manquait !
    case squareDiagonals
    
    var id: String { rawValue }
}
