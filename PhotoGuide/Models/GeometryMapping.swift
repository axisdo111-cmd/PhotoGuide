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

// MARK: - Camera visible frame (aspectFill, UNIQUE SOURCE)
func cameraVisibleFrame(
    container: CGSize,
    cameraAspect: CGFloat
) -> CGRect {

    let containerAspect = container.width / container.height

    if containerAspect > cameraAspect {
        // écran trop large → crop horizontal
        let height = container.height
        let width = height * cameraAspect
        let x = (container.width - width) / 2
        return CGRect(x: x, y: 0, width: width, height: height)
    } else {
        // écran trop haut → crop vertical
        let width = container.width
        let height = width / cameraAspect
        let y = (container.height - height) / 2
        return CGRect(x: 0, y: y, width: width, height: height)
    }
}

// MARK: - Normalized → Screen mapping (NO ROTATION)
func mapSpiralPoint(
    _ p: CGPoint,
    size: CGSize,
    sensorAspect: CGFloat
) -> CGPoint {

    let frame = cameraVisibleFrame(
        container: size,
        cameraAspect: sensorAspect
    )

    return CGPoint(
        x: frame.minX + p.x * frame.width,
        y: frame.minY + p.y * frame.height
    )
}




