//
//  OrientationManager.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 11/12/2025.
//

import SwiftUI
import Combine
import AVFoundation

class OrientationManager: ObservableObject {
    @Published var isLandscape: Bool = false
    
    private var cancellable: AnyCancellable?
    
    init() {
        update() // état initial
        
        cancellable = NotificationCenter.default
            .publisher(for: UIDevice.orientationDidChangeNotification)
            .sink { _ in self.update() }
    }
    
    private func update() {
        let o = UIDevice.current.orientation
        
        switch o {
        case .landscapeLeft, .landscapeRight:
            isLandscape = true
        case .portrait, .portraitUpsideDown:
            isLandscape = false
        default:
            break
        }
    }
}

