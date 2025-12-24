//
//  CameraGeometry.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 22/12/2025.
//

import SwiftUI

/// Frame EXACT affiché par la caméra quand videoGravity = .resizeAspectFill
func sensorFrameAspectFill(
    container: CGSize,
    cameraAspect: CGFloat
) -> CGRect {

    let containerAspect = container.width / container.height

    if cameraAspect > containerAspect {
        // Image plus large → crop gauche / droite
        let height = container.height
        let width = height * cameraAspect
        let x = (container.width - width) / 2

        return CGRect(x: x, y: 0, width: width, height: height)
    } else {
        // Image plus haute → crop haut / bas
        let width = container.width
        let height = width / cameraAspect
        let y = (container.height - height) / 2

        return CGRect(x: 0, y: y, width: width, height: height)
    }
}
