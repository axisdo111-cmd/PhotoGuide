//
//  DynamicSymmetry.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 10/12/2025.
//

import SwiftUI

private func dynamicSymmetryGrid(ratio: CGFloat) -> [OverlayLine] {
    let h = 1 / ratio
    let y = (1 - h) / 2
    
    return [
        OverlayLine(x1: 0, y1: y,   x2: 1, y2: y),
        OverlayLine(x1: 0, y1: 1-y, x2: 1, y2: 1-y),
        OverlayLine(x1: 0, y1: y,   x2: 1, y2: 1-y),
        OverlayLine(x1: 0, y1: 1-y, x2: 1, y2: y)
    ]
}

func dynamicSymmetryRootPhi() -> [OverlayLine] {
    dynamicSymmetryGrid(ratio: (1 + sqrt(5)) / 2)
}

