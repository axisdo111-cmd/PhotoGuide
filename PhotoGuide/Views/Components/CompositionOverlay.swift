//
//  CompositionOverlay.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH
//

import SwiftUI

struct CompositionOverlay: View {

    @ObservedObject var vm: CompositionViewModel
    @EnvironmentObject var orientation: OrientationManager

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(vm.elements) { element in
                    elementView(
                        element,
                        geo: geo
                    )
                }
            }
            .clipShape(
                Rectangle().path(
                    in: sensorFrame(
                        in: geo.size,
                        aspect: vm.spiralConfig.aspectRatio
                    )
                )
            )
        }
        .allowsHitTesting(false)
    }

    // MARK: - Element Rendering

    @ViewBuilder
    private func elementView(
        _ element: OverlayElement,
        geo: GeometryProxy
    ) -> some View {

        switch element {

        case .line(let l):
            Path { path in
                let p1 = mapSpiralPoint(
                    CGPoint(x: l.x1, y: l.y1),
                    size: geo.size,
                    sensorAspect: vm.spiralConfig.aspectRatio,
                    isLandscape: orientation.isLandscape
                )

                let p2 = mapSpiralPoint(
                    CGPoint(x: l.x2, y: l.y2),
                    size: geo.size,
                    sensorAspect: vm.spiralConfig.aspectRatio,
                    isLandscape: orientation.isLandscape
                )

                path.move(to: p1)
                path.addLine(to: p2)
            }
            .stroke(
                vm.lineColor.opacity(vm.lineOpacity),
                lineWidth: vm.lineWidth
            )

        case .curve(let c):
            Path { path in
                guard let first = c.points.first else { return }

                path.move(
                    to: mapSpiralPoint(
                        first,
                        size: geo.size,
                        sensorAspect: vm.spiralConfig.aspectRatio,
                        isLandscape: orientation.isLandscape
                    )
                )

                for p in c.points.dropFirst() {
                    path.addLine(
                        to: mapSpiralPoint(
                            p,
                            size: geo.size,
                            sensorAspect: vm.spiralConfig.aspectRatio,
                            isLandscape: orientation.isLandscape
                        )
                    )
                }
            }
            .stroke(
                vm.lineColor.opacity(vm.lineOpacity),
                lineWidth: vm.lineWidth
            )

        case .highlightPoint(let p):
            let pp = mapSpiralPoint(
                p,
                size: geo.size,
                sensorAspect: vm.spiralConfig.aspectRatio,
                isLandscape: orientation.isLandscape
            )

            Circle()
                .stroke(
                    vm.lineColor.opacity(vm.lineOpacity),
                    lineWidth: vm.lineWidth
                )
                .frame(width: 24, height: 24)
                .position(pp)
        }
    }
}
