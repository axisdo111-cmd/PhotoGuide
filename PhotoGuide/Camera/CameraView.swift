//
//  CameraView.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 10/12/2025.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewRepresentable {

    let session: AVCaptureSession

    final class PreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }

        var previewLayer: AVCaptureVideoPreviewLayer {
            layer as! AVCaptureVideoPreviewLayer
        }
    }

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {
        guard let windowScene = uiView.window?.windowScene else { return }
        guard let connection = uiView.previewLayer.connection else { return }

        // iOS 17+
        if #available(iOS 17.0, *) {
            let angle = rotationAngle(from: windowScene.interfaceOrientation)
            connection.videoRotationAngle = angle
        }
    }

    @available(iOS 17.0, *)
    private func rotationAngle(from orientation: UIInterfaceOrientation) -> CGFloat {
        switch orientation {
        case .portrait: return 0
        case .landscapeLeft: return 90
        case .portraitUpsideDown: return 180
        case .landscapeRight: return 270
        default: return 0
        }
    }
}

    
extension UIInterfaceOrientation {
    var rotationAngle: CGFloat {
        switch self {
        case .portrait: return 0
        case .landscapeRight: return 90
        case .portraitUpsideDown: return 180
        case .landscapeLeft: return 270
        default: return 0
        }
    }
}
