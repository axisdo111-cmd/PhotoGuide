//
//  MainToolPanel.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 10/12/2025.
//

import SwiftUI

struct MainToolPanel: View {
    @Binding var mode: ToolPanelMode
    
    @ObservedObject var compositionVM: CompositionViewModel
    @ObservedObject var exposureVM: ExposureViewModel
    @ObservedObject var colorVM: ColorHarmonyViewModel
    
    @Namespace private var selectionNamespace
    
    var body: some View {
        VStack(spacing: 14) {
            
            // MARK: - BARRE DES MODES
            modeBar
            
            // MARK: - CONTENU DYNAMIQUE
            VStack {
                toolContent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, mode == .color ? -10 : 6)   // ← 🔼 REMONTE LE MODE COULEUR
            }
            .frame(height: mode == .color ? 360 : 260)        // ← 🔼 PANEL PLUS GRAND EN MODE COULEUR
            .transition(.opacity.combined(with: .scale))
        }
        .padding(.horizontal, 18)
        .padding(.top, 10)     // ← 🔼 Remonte encore légèrement le panel entier
        .padding(.bottom, 18)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: .black.opacity(0.35), radius: 30, x: 0, y: 20)
        
        .frame(maxWidth: 380)
        .padding(.horizontal, 10)
        .padding(.bottom, 12)
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: mode)
    }
    
    // MARK: - Contenu dynamique
    @ViewBuilder
    private var toolContent: some View {
        switch mode {
        case .composition:
            CompositionControlsView(vm: compositionVM)
                .frame(maxHeight: .infinity)
        
        case .exposure:
            ExposureTriangle(vm: exposureVM)
                .frame(maxHeight: .infinity)
        
        case .color:
            ColorHarmonyView(vm: colorVM)
                .frame(maxHeight: .infinity)
        }
    }
    
    // MARK: - Barre de modes
    private var modeBar: some View {
        HStack(spacing: 16) {
            ForEach(ToolPanelMode.allCases) { item in
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        mode = item
                    }
                } label: {
                    VStack(spacing: 6) {
                        
                        ZStack {
                            if mode == item {
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(item.accentColor.opacity(0.7))
                                    .matchedGeometryEffect(
                                        id: "modeBackground",
                                        in: selectionNamespace
                                    )
                            }
                            
                            Image(systemName: item.iconName)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(mode == item ? .white : .secondary)
                                .padding(10)
                        }
                        .frame(width: 44, height: 44)
                        
                        Text(item.iconName)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
