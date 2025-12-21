//
//  TetrahedronIcon.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 12/12/2025.
//

import SwiftUI

struct TetrahedronIcon: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            Path { path in
                let top   = CGPoint(x: w / 2, y: 0)
                let left  = CGPoint(x: 0,     y: h)
                let right = CGPoint(x: w,     y: h)
                let mid   = CGPoint(x: w * 0.65, y: h * 0.45)

                // Face principale
                path.move(to: top)
                path.addLine(to: left)
                path.addLine(to: right)
                path.closeSubpath()

                // Arêtes internes
                path.move(to: top)
                path.addLine(to: mid)
                path.addLine(to: right)

                path.move(to: left)
                path.addLine(to: mid)
            }
            .stroke(Color.white, lineWidth: 1.6)   // ✅ ICI
        }
        .background(Color.clear)
        .aspectRatio(1, contentMode: .fit)
    }
}
