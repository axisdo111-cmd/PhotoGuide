//
//  CompositionViewModel.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 10/12/2025.
//
//
//  CompositionViewModel.swift
//  PhotoGuide
//

import SwiftUI

class CompositionViewModel: ObservableObject {

    // MARK: - UI settings
    @Published var mode: CompositionMode = .ruleOfThirds
    @Published var lineColor: Color = .white
    @Published var lineOpacity: Double = 0.9
    @Published var lineWidth: CGFloat = 1.4
    @Published var spiralConfig = GoldenSpiralConfig()

    // MARK: - LINE-BASED overlays
    var lines: [OverlayLine] {
        switch mode {

        case .ruleOfThirds:
            return ruleOfThirds()

        case .goldenRatio:
            return goldenRatio()

        case .goldenSpiral:
            return []   // handled in elements

        case .goldenTriangle:
            return goldenTriangle()

        case .fibonacciMatrix:
            return fibonacciMatrix()

        case .fibonacciDiagonals:
            return fibonacciDiagonals()

        case .harmonicArmature:
            return harmonicArmature()

        case .dynamicSymmetryRoot2:
            return dynamicSymmetryRoot2()   // FIXED

        case .dynamicSymmetryRoot3:
            return dynamicSymmetryRoot3()   // FIXED

        case .dynamicSymmetryRoot5:
            return dynamicSymmetryRoot5()   // FIXED

        case .squareDiagonals:
            return squareDiagonals()        // FIXED
        }
    }

    // MARK: - FULL overlay (lines + curves + highlight points)
    var elements: [OverlayElement] {

        // Base lines
        var rendered: [OverlayElement] = lines.map { .line($0) }

        switch mode {

        // GOLDEN SPIRAL
        case .goldenSpiral:
            return buildGoldenSpiralElements(config: spiralConfig)

        // Rule of thirds – add focal points
        case .ruleOfThirds:
            for x in [1.0/3.0, 2.0/3.0] {
                for y in [1.0/3.0, 2.0/3.0] {
                    rendered.append(.highlightPoint(.init(x: x, y: y)))
                }
            }

        default:
            break
        }

        return rendered
    }

}
