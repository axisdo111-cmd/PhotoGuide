//
//  OverlayLine.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 10/12/2025.
//

import SwiftUI

/// Représente une ligne normalisée à tracer en overlay (0–1 dans les deux axes)
struct OverlayLine: Identifiable {
    let id = UUID()
    let x1: CGFloat
    let y1: CGFloat
    let x2: CGFloat
    let y2: CGFloat
}

extension OverlayLine {
    var start: CGPoint { CGPoint(x: x1, y: y1) }
    var end: CGPoint   { CGPoint(x: x2, y: y2) }
}
