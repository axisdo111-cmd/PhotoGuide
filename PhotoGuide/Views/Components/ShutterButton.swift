//
//  ShutterButton.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 10/12/2025.
//

import SwiftUI

struct ShutterButton: View {
    var action: () -> Void
    
    @State private var scale: CGFloat = 1.0
    @State private var flashOpacity: Double = 0.0
    
    var body: some View {
        ZStack {
            // Flash écran
            Color.white
                .opacity(flashOpacity)
                .ignoresSafeArea()
                .animation(.easeOut(duration: 0.25), value: flashOpacity)
            
            Button {
                captureEffect()
                action()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.18))
                        .frame(width: 90, height: 90)
                    
                    Circle()
                        .stroke(Color.white, lineWidth: 5)
                        .frame(width: 75, height: 75)
                        .scaleEffect(scale)
                }
            }
        }
    }
    
    private func captureEffect() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        
        withAnimation(.spring(response: 0.25, dampingFraction: 0.4)) {
            scale = 0.75
        }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5).delay(0.05)) {
            scale = 1.0
        }
        
        // Flash
        flashOpacity = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            flashOpacity = 0
        }
    }
}
