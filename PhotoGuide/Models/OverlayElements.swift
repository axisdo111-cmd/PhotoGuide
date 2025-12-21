//
//  OverlayElements.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 10/12/2025.
//

import Foundation
import CoreGraphics

// MARK: - Courbe normalisée 0–1
struct OverlayCurve {
    let points: [CGPoint]
}

// MARK: - Éléments dessinables (ligne, courbe, point focal)
enum OverlayElement: Identifiable {

    case line(OverlayLine)
    case curve(OverlayCurve)
    case highlightPoint(CGPoint)

    // Identité STABLE, déterministe
    var id: String {
        switch self {

        case .line(let l):
            return "line:\(l.id)"

        case .curve(let c):
            guard let first = c.points.first else {
                return "curve:empty"
            }
            return "curve:\(first.x.rounded(toPlaces: 6)):\(first.y.rounded(toPlaces: 6)):\(c.points.count)"

        case .highlightPoint(let p):
            return "point:\(p.x.rounded(toPlaces: 6)):\(p.y.rounded(toPlaces: 6))"
        }
    }
}

// MARK: - Helpers
private extension CGFloat {
    func rounded(toPlaces places: Int) -> CGFloat {
        let factor = pow(10, CGFloat(places))
        return (self * factor).rounded() / factor
    }
}
