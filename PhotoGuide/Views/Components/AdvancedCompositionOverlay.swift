//
//  AdvancedCompositionOverlay.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 10/12/2025.
//
//

import SwiftUI

struct AdvancedCompositionOverlay: View {

    @ObservedObject var vm: CompositionViewModel
    let sensorAspect: CGFloat

    @State private var progress: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let size = geo.size

            ZStack {
                drawLines(size: size)
                drawCurves(size: size)
                drawHighlights(size: size)
            }
            .onAppear {
                progress = 0
                withAnimation(.easeInOut(duration: 6.0)) {
                    progress = 1
                }
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - LIGNES
extension AdvancedCompositionOverlay {

    func drawLines(size: CGSize) -> some View {
        Path { path in
            for case let .line(line) in vm.elements {

                let p1 = mapSpiralPoint(
                    CGPoint(x: line.x1, y: line.y1),
                    size: size,
                    sensorAspect: sensorAspect
                )

                let p2 = mapSpiralPoint(
                    CGPoint(x: line.x2, y: line.y2),
                    size: size,
                    sensorAspect: sensorAspect
                )

                path.move(to: p1)
                path.addLine(to: p2)
            }
        }
        .trim(from: 0, to: progress)
        .stroke(
            vm.lineColor.opacity(vm.lineOpacity),
            style: StrokeStyle(
                lineWidth: vm.lineWidth,
                dash: [10, 10],
                dashPhase: progress * 20
            )
        )
    }
}

// MARK: - COURBES
extension AdvancedCompositionOverlay {

    func drawCurves(size: CGSize) -> some View {
        Path { path in
            for case let .curve(curve) in vm.elements {
                guard let first = curve.points.first else { continue }

                let start = mapSpiralPoint(
                    first,
                    size: size,
                    sensorAspect: sensorAspect
                )

                path.move(to: start)

                for p in curve.points.dropFirst() {
                    path.addLine(
                        to: mapSpiralPoint(
                            p,
                            size: size,
                            sensorAspect: sensorAspect
                        )
                    )
                }
            }
        }
        .trim(from: 0, to: progress)
        .stroke(
            vm.lineColor.opacity(vm.lineOpacity),
            style: StrokeStyle(lineWidth: vm.lineWidth + 0.4)
        )
    }
}

// MARK: - POINTS
extension AdvancedCompositionOverlay {

    func drawHighlights(size: CGSize) -> some View {
        ForEach(Array(vm.elements.enumerated()), id: \.offset) { _, element in
            if case let .highlightPoint(p) = element {

                let pos = mapSpiralPoint(
                    p,
                    size: size,
                    sensorAspect: sensorAspect
                )

                Circle()
                    .fill(Color.red)
                    .frame(width: 12, height: 12)
                    .position(pos)

            }
        }
    }
}
