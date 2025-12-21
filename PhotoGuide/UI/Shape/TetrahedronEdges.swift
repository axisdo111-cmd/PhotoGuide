//
//  TetrahedronEdges.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 12/12/2025.
//

import SwiftUI

struct TetrahedronEdges: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let pTop = CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.05)
        let pLeft = CGPoint(x: rect.minX + rect.width * 0.1, y: rect.height * 0.8)
        let pRight = CGPoint(x: rect.maxX - rect.width * 0.1, y: rect.height * 0.8)
        let pBottom = CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.05)

        path.move(to: pTop)
        path.addLine(to: pLeft)

        path.move(to: pTop)
        path.addLine(to: pRight)

        path.move(to: pLeft)
        path.addLine(to: pRight)

        path.move(to: pTop)
        path.addLine(to: pBottom)

        path.move(to: pBottom)
        path.addLine(to: pRight)

        return path
    }
}
