//
//  CompositionOverlays.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 10/12/2025.
//

import SwiftUI

// MARK: - Helpers
@inline(__always)
func vline(_ x: CGFloat) -> OverlayLine { OverlayLine(x1: x, y1: 0, x2: x, y2: 1) }

@inline(__always)
func hline(_ y: CGFloat) -> OverlayLine { OverlayLine(x1: 0, y1: y, x2: 1, y2: y) }

@inline(__always)
func diag(_ a: CGPoint, _ b: CGPoint) -> OverlayLine {
    OverlayLine(x1: a.x, y1: a.y, x2: b.x, y2: b.y)
}

// MARK: - Rule of Thirds
func ruleOfThirds() -> [OverlayLine] {
    let thirds: [CGFloat] = [1.0/3.0, 2.0/3.0]
    return thirds.flatMap { t in [vline(t), hline(t)] }
}

// MARK: - Golden Ratio Grid
func goldenRatio() -> [OverlayLine] {
    let φ: CGFloat = 0.618
    let inv = 1 - φ
    return [vline(φ), vline(inv), hline(φ), hline(inv)]
}

// MARK: - Harmonic Armature
func harmonicArmature() -> [OverlayLine] {
    var lines: [OverlayLine] = [
        diag(.init(x: 0, y: 0), .init(x: 1, y: 1)),
        diag(.init(x: 0, y: 1), .init(x: 1, y: 0))
    ]
    
    let m: CGFloat = 0.5
    lines += [
        diag(.init(x: 0, y: m), .init(x: m, y: 0)),
        diag(.init(x: m, y: 0), .init(x: 1, y: m)),
        diag(.init(x: 1, y: m), .init(x: m, y: 1)),
        diag(.init(x: m, y: 1), .init(x: 0, y: m))
    ]
    return lines
}

// MARK: - Golden Triangle
func goldenTriangle() -> [OverlayLine] {
    [
        diag(.init(x: 0, y: 0), .init(x: 1, y: 1)),
        diag(.init(x: 1, y: 0), .init(x: 0, y: 1))
    ]
}

// MARK: - Square Diagonals
func squareDiagonals() -> [OverlayLine] {
    [
        diag(.init(x: 0, y: 0), .init(x: 1, y: 1)),  // Diagonale ↗
        diag(.init(x: 1, y: 0), .init(x: 0, y: 1))   // Diagonale ↘
    ]
}

// MARK: - Fibonacci Matrix
func fibonacciMatrix() -> [OverlayLine] {
    let ratios: [CGFloat] = [1.0/2.0, 2.0/3.0, 3.0/5.0, 5.0/8.0]
    return ratios.flatMap { t in [vline(t), hline(t)] }
}

// MARK: - Fibonacci Diagonal Cross
func fibonacciDiagonals() -> [OverlayLine] {
    [
        diag(.init(x: 0, y: 0), .init(x: 1, y: 1)),
        diag(.init(x: 0, y: 1), .init(x: 1, y: 0))
    ]
}

// MARK: - Dynamic Symmetry Root2
func dynamicSymmetryRoot2() -> [OverlayLine] {
    let ratio = sqrt(2.0)
    let h = 1 / ratio
    let y = (1 - h) / 2    // centre le module

    var lines: [OverlayLine] = []

    // Contours horizontaux du module
    lines.append(hline(y))
    lines.append(hline(1 - y))

    // Diagonales internes académiques
    lines.append(diag(.init(x: 0, y: y),     .init(x: 1, y: 1 - y)))
    lines.append(diag(.init(x: 0, y: 1 - y), .init(x: 1, y: y)))

    return lines
}

// MARK: - Dynamic Symmetry Root3
func dynamicSymmetryRoot3() -> [OverlayLine] {
    let ratio = sqrt(3.0)
    let h = 1 / ratio
    let y = (1 - h) / 2

    var lines: [OverlayLine] = []

    // Contours
    lines.append(hline(y))
    lines.append(hline(1 - y))

    // Diagonales
    lines.append(diag(.init(x: 0, y: y),     .init(x: 1, y: 1 - y)))
    lines.append(diag(.init(x: 0, y: 1 - y), .init(x: 1, y: y)))

    return lines
}

import CoreGraphics

// MARK: - Golden Spiral (curve-only) built from Fibonacci squares inside sensor rect (0–1)
func goldenSpiralCurve(
    steps: Int = 8,
    samplesPerArc: Int = 24,
    aspectRatio: CGFloat,
    clockwise: Bool = true,
    mirror: Bool = false
) -> OverlayCurve {

    let squares = fibonacciSquares(steps: steps, aspectRatio: aspectRatio, clockwise: clockwise)

    var points: [CGPoint] = []

    for (i, r) in squares.enumerated() {

        // quarter circle per square (matches the builder logic)
        let idx = i % 4

        let center: CGPoint
        let startAngle: CGFloat
        let endAngle: CGFloat

        switch idx {
        case 0:
            center = CGPoint(x: r.maxX, y: r.maxY)
            startAngle = .pi
            endAngle   = 1.5 * .pi
        case 1:
            center = CGPoint(x: r.minX, y: r.maxY)
            startAngle = 1.5 * .pi
            endAngle   = 2 * .pi
        case 2:
            center = CGPoint(x: r.minX, y: r.minY)
            startAngle = 0
            endAngle   = .pi / 2
        default:
            center = CGPoint(x: r.maxX, y: r.minY)
            startAngle = .pi / 2
            endAngle   = .pi
        }

        let radius = r.width // square

        for s in 0...samplesPerArc {
            let t = CGFloat(s) / CGFloat(samplesPerArc)
            let a = startAngle + t * (endAngle - startAngle)

            var p = CGPoint(
                x: center.x + cos(a) * radius,
                y: center.y + sin(a) * radius
            )

            if mirror {
                p.x = 1 - p.x
            }
            points.append(p)
        }
    }

    return OverlayCurve(points: points)
}

// MARK: - Fibonacci squares inside a centered sensor rect (normalized 0–1)
private enum SpiralDir { case right, down, left, up
    mutating func rotateCW() {
        self = switch self {
        case .right: .down
        case .down: .left
        case .left: .up
        case .up: .right
        }
    }
}

func fibonacciSquares(
    steps: Int,
    aspectRatio: CGFloat,
    clockwise: Bool = true
) -> [CGRect] {

    // 1) start rect = centered sensor rect in 0–1 (same spirit as sensorFrame)
    var rect: CGRect
    if aspectRatio >= 1 {
        // landscape sensor inside 1x1 => height smaller, centered vertically
        let h = 1 / aspectRatio
        rect = CGRect(x: 0, y: (1 - h) / 2, width: 1, height: h)
    } else {
        // portrait sensor inside 1x1 => width smaller, centered horizontally
        let w = aspectRatio
        rect = CGRect(x: (1 - w) / 2, y: 0, width: w, height: 1)
    }

    // 2) iterate: remove a square from rect, keep remainder
    var squares: [CGRect] = []

    // IMPORTANT: choose initial direction so the first square starts "from the top"
    // In iOS coordinates: y increases downward.
    // If you want a spiral that visually starts near the TOP edge and goes clockwise,
    // the most reliable is: first square at TOP-LEFT of the sensor rect.
    var dir: SpiralDir = .right

    for _ in 0..<steps {
        let side = min(rect.width, rect.height)

        let square: CGRect
        let remaining: CGRect

        switch dir {

        case .right:
            // carré en HAUT-GAUCHE
            square = CGRect(x: rect.minX,
                            y: rect.minY,
                            width: side,
                            height: side)
            remaining = CGRect(x: rect.minX + side,
                               y: rect.minY,
                               width: rect.width - side,
                               height: rect.height)

        case .down:
            // carré en HAUT-DROITE
            square = CGRect(x: rect.maxX - side,
                            y: rect.minY,
                            width: side,
                            height: side)
            remaining = CGRect(x: rect.minX,
                               y: rect.minY + side,
                               width: rect.width,
                               height: rect.height - side)

        case .left:
            // carré en BAS-DROITE
            square = CGRect(x: rect.maxX - side,
                            y: rect.maxY - side,
                            width: side,
                            height: side)
            remaining = CGRect(x: rect.minX,
                               y: rect.minY,
                               width: rect.width - side,
                               height: rect.height)

        case .up:
            // carré en BAS-GAUCHE
            square = CGRect(x: rect.minX,
                            y: rect.maxY - side,
                            width: side,
                            height: side)
            remaining = CGRect(x: rect.minX,
                               y: rect.minY,
                               width: rect.width,
                               height: rect.height - side)
        }


        squares.append(square)
        rect = remaining

        if clockwise {
            dir.rotateCW()
        } else {
            // rotate CCW
            dir = switch dir {
            case .right: .up
            case .up: .left
            case .left: .down
            case .down: .right
            }
        }
    }

    return squares
}


// MARK: - Dynamic Symmetry Root5
func dynamicSymmetryRoot5() -> [OverlayLine] {
    let ratio = sqrt(5.0)
    let h = 1 / ratio
    let y = (1 - h) / 2

    var lines: [OverlayLine] = []

    // Contours
    lines.append(hline(y))
    lines.append(hline(1 - y))

    // Diagonales (rabbeting lines)
    lines.append(diag(.init(x: 0, y: y),     .init(x: 1, y: 1 - y)))
    lines.append(diag(.init(x: 0, y: 1 - y), .init(x: 1, y: y)))

    return lines
}
