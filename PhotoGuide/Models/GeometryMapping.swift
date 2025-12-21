//
//  GeometryMapping.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 10/12/2025.
//

import SwiftUI

/// Calcule le rectangle du "capteur" dans l'écran selon aspect ratio (4:3, 16:9…)
func sensorFrame(in size: CGSize, aspect: CGFloat) -> CGRect {
    let viewAspect = size.width / size.height
    
    if viewAspect > aspect {
        let h = size.height
        let w = h * aspect
        return CGRect(x: (size.width - w)/2, y: 0, width: w, height: h)
    } else {
        let w = size.width
        let h = w / aspect
        return CGRect(x: 0, y: (size.height - h)/2, width: w, height: h)
    }
}

/// Applique l'orientation portrait/paysage aux points normalisés
func mapNormalized(_ p: CGPoint,
                   in rect: CGRect,
                   isLandscape: Bool) -> CGPoint {
    
    let nx: CGFloat
    let ny: CGFloat
    
    if isLandscape {
        nx = p.y
        ny = 1 - p.x
    } else {
        nx = p.x
        ny = p.y
    }
    
    return CGPoint(
        x: rect.minX + nx * rect.width,
        y: rect.minY + ny * rect.height
    )
}

/// Mapping spécifique aux spirales (évite toute double transformation)
func mapSpiralPoint(
    _ p: CGPoint,
    size: CGSize,
    sensorAspect: CGFloat,
    isLandscape: Bool
) -> CGPoint {

    // Cadre capteur réel dans l’écran
    let rect = sensorFrame(in: size, aspect: sensorAspect)

    // Orientation device
    let nx: CGFloat
    let ny: CGFloat

    if isLandscape {
        nx = p.y
        ny = 1 - p.x
    } else {
        nx = p.x
        ny = p.y
    }

    // Projection directe → écran
    return CGPoint(
        x: rect.minX + nx * rect.width,
        y: rect.minY + ny * rect.height
    )
}

