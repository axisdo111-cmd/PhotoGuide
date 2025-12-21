//
//  CameraScreen.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 10/12/2025.
//

import SwiftUI

struct CameraScreen: View {
    
    @StateObject private var cam          = CameraManager()
    @StateObject private var composition  = CompositionViewModel()
    @StateObject private var exposure     = ExposureViewModel()
    @StateObject private var colorVM      = ColorHarmonyViewModel()
    @StateObject private var orientation = OrientationManager()
    
    @State private var showThumbnail = false
    @State private var toolMode: ToolPanelMode = .composition
    @State private var showLastPhoto = false
    @State private var showPanel = true   // ← cacher/montrer le panneau

    var body: some View {
        GeometryReader { geo in
            let safeArea = geo.safeAreaInsets

            ZStack {
                CameraView(session: cam.session)
                    .environmentObject(orientation)     // ← ESSENTIEL
                    .ignoresSafeArea()

                AdvancedCompositionOverlay(vm: composition, sensorAspect: 4.0/3.0)
                    .environmentObject(orientation)     // ← ESSENTIEL
                    .ignoresSafeArea()

                captureControls(safeArea: safeArea)

                if showPanel {
                    VStack {
                        Spacer()
                        MainToolPanel(mode: $toolMode,
                                      compositionVM: composition,
                                      exposureVM: exposure,
                                      colorVM: colorVM)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .padding(.bottom, safeArea.bottom + 10)
                    }
                }

                panelToggleButton(safeArea: safeArea)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }


    // MARK: - Bouton show/hide MainToolPanel
    private func panelToggleButton(safeArea: EdgeInsets) -> some View {
        VStack {
            Spacer()
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    showPanel.toggle()
                }
            } label: {
                Image(systemName: showPanel ? "chevron.down" : "chevron.up")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
            .padding(.bottom, showPanel ? safeArea.bottom + 260 : safeArea.bottom + 60)
        }
        .animation(.easeInOut, value: showPanel)
    }


    // MARK: - UI capture & overlay
    private func captureControls(safeArea: EdgeInsets) -> some View {
        VStack {
            Spacer()

            HStack {
                if showThumbnail, let image = cam.capturedImage {
                    Button {
                        showLastPhoto = true
                    } label: {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipped()
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.white, lineWidth: 1)
                            )
                            .transition(.scale.combined(with: .opacity))
                            .animation(.easeInOut, value: showThumbnail)
                    }
                    .padding(.leading, 24)
                } else {
                    Spacer().frame(width: 74)
                }


                Spacer()

                // Bouton de prise de vue
                ShutterButton {
                    cam.takePhoto()

                    // Affiche la vignette pendant 5 sec
                    showThumbnail = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation {
                            showThumbnail = false
                        }
                    }
                }


                Spacer()
                Spacer().frame(width: 74)
            }
            .padding(.bottom, showPanel ? safeArea.bottom + 120 : safeArea.bottom + 40)
        }
    }

}
