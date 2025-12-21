//
//  TetrahedronFace.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 12/12/2025.
//

import SwiftUI

struct TetrahedronFace: Shape {
    let points: [CGPoint]

    func path(in rect: CGRect) -> Path {
        var path = Path()

        guard points.count >= 3 else { return path }

        let scaled = points.map {
            CGPoint(
                x: rect.minX + $0.x * rect.width,
                y: rect.minY + $0.y * rect.height
            )
        }

        path.move(to: scaled[0])
        for p in scaled.dropFirst() {
            path.addLine(to: p)
        }
        path.closeSubpath()

        return path
    }
}
