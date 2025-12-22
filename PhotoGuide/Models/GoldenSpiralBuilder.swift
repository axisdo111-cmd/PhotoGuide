//
//  GoldenSpiralBuilder.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 20/12/2025.
//

import SwiftUI
import CoreGraphics

let __compiler_reaches_this_file = true


struct GoldenSpiralConfig {
    var steps: Int = 8
    var samplesPerArc: Int = 32
    var showRectangles: Bool = false
    var mirror: Bool = false
    var aspectRatio: CGFloat = 1.0
    //var rotation: Angle = .degrees(0)
    var clockwise: Bool = true
    
}
enum SpiralDirection {
    case right
    case down
    case left
    case up
    
    // Construction Sens Horaire
    mutating func rotateClockwise() {
        self = switch self {
        case .right: .down
        case .down: .left
        case .left: .up
        case .up: .right
        }
    }
    
    // Construction Sens Anti-Horaire
    mutating func rotateCounterClockwise() {
        self = switch self {
        case .right: .up
        case .up: .left
        case .left: .down
        case .down: .right
        }
    }
}
// MARK: - Builder (GLOBAL)
func buildGoldenSpiralElements(
    config: GoldenSpiralConfig
) -> [OverlayElement] {
    
    var elements: [OverlayElement] = []
    
    let aspect = config.aspectRatio
    
    // Rectangle de départ (capteur, normalisé 0–1)
    var rect: CGRect
    if aspect >= 1 {
        rect = CGRect(
            x: 0,
            y: (1 - 1 / aspect) / 2,
            width: 1,
            height: 1 / aspect
        )
    } else {
        rect = CGRect(
            x: (1 - aspect) / 2,
            y: 0,
            width: aspect,
            height: 1
        )
    }
    
    var direction: SpiralDirection = .up
    
    for _ in 0..<config.steps {
        
        let side = min(rect.width, rect.height)
        
        let square: CGRect
        let remaining: CGRect
        
        switch direction {
            
        case .up:
            // carré en haut à droite
            square = CGRect(
                x: rect.maxX - side,
                y: rect.minY,
                width: side,
                height: side
            )
            remaining = CGRect(
                x: rect.minX,
                y: rect.minY + side,
                width: rect.width,
                height: rect.height - side
            )
            
        case .right:
            // carré en bas à droite
            square = CGRect(
                x: rect.maxX - side,
                y: rect.maxY - side,
                width: side,
                height: side
            )
            remaining = CGRect(
                x: rect.minX,
                y: rect.minY,
                width: rect.width - side,
                height: rect.height
            )
            
        case .down:
            // carré en bas à gauche
            square = CGRect(
                x: rect.minX,
                y: rect.maxY - side,
                width: side,
                height: side
            )
            remaining = CGRect(
                x: rect.minX,
                y: rect.minY,
                width: rect.width,
                height: rect.height - side
            )
            
        case .left:
            // carré en haut à gauche
            square = CGRect(
                x: rect.minX,
                y: rect.minY,
                width: side,
                height: side
            )
            remaining = CGRect(
                x: rect.minX + side,
                y: rect.minY,
                width: rect.width - side,
                height: rect.height
            )
        }
        
        // Quart de cercle
        let arc = quarterCircle(
            in: square,
            direction: direction,
            samples: config.samplesPerArc,
            mirror: config.mirror
        )
        
        elements.append(.curve(OverlayCurve(points: arc)))
        
        if config.showRectangles {
            elements.append(contentsOf: rectToLines(square))
        }
        
        // Sens de la Construction
        rect = remaining
        if config.clockwise {
            direction.rotateClockwise()
        } else {
            direction.rotateCounterClockwise()
        }
        
    }
    return elements
}
    
// ====================================================
// MARK: - Helpers
// ====================================================
func quarterCircle(
    in rect: CGRect,
    direction: SpiralDirection,
    samples: Int,
    mirror: Bool
) -> [CGPoint] {
    
    let radius = rect.width
    let center: CGPoint
    let startAngle: CGFloat
    let endAngle: CGFloat
    
    switch direction {
        
    case .right:
        // arc bas-droit → bas-gauche
        center = CGPoint(x: rect.maxX, y: rect.maxY)
        startAngle = .pi
        endAngle   = 1.5 * .pi
        
    case .down:
        // arc bas-gauche → haut-gauche
        center = CGPoint(x: rect.minX, y: rect.maxY)
        startAngle = 1.5 * .pi
        endAngle   = 2 * .pi
        
    case .left:
        // arc haut-gauche → haut-droit
        center = CGPoint(x: rect.minX, y: rect.minY)
        startAngle = 0
        endAngle   = .pi / 2
        
    case .up:
        // arc haut-droit → bas-droit
        center = CGPoint(x: rect.maxX, y: rect.minY)
        startAngle = .pi / 2
        endAngle   = .pi
    }
    
    var points: [CGPoint] = []
    
    for i in 0...samples {
        let t = CGFloat(i) / CGFloat(samples)
        let angle = startAngle + t * (endAngle - startAngle)
        
        var p = CGPoint(
            x: center.x + cos(angle) * radius,
            y: center.y + sin(angle) * radius
        )
        
        if mirror {
            p.x = 1 - p.x
        }
        
        points.append(p)
    }
    
    return points
}


private func rotate(point: CGPoint, angle: Angle) -> CGPoint {
    let c = cos(angle.radians)
    let s = sin(angle.radians)

    let x = point.x - 0.5
    let y = point.y - 0.5

    return CGPoint(
        x: x * c - y * s + 0.5,
        y: x * s + y * c + 0.5
    )
}

private func rectToLines(_ r: CGRect) -> [OverlayElement] {
    [
        .line(OverlayLine(x1: r.minX, y1: r.minY, x2: r.maxX, y2: r.minY)),
        .line(OverlayLine(x1: r.maxX, y1: r.minY, x2: r.maxX, y2: r.maxY)),
        .line(OverlayLine(x1: r.maxX, y1: r.maxY, x2: r.minX, y2: r.maxY)),
        .line(OverlayLine(x1: r.minX, y1: r.maxY, x2: r.minX, y2: r.minY))
    ]
}
