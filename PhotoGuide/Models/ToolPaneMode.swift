//
//  ToolPaneMode.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 10/12/2025.
//

import SwiftUI

enum ToolPanelMode: Int, CaseIterable, Identifiable {
    case composition
    case exposure
    case color

    var id: Int { rawValue }
}

extension ToolPanelMode {
    var iconName: String {
        switch self {
        case .composition: return "square.grid.3x3"
        case .exposure:    return "camera.aperture"
        case .color:       return "swatchpalette"
        }
    }
    
    var accentColor: Color {
        switch self {
        case .composition: return .blue
        case .exposure:    return .orange
        case .color:       return .purple
        }
    }
}

